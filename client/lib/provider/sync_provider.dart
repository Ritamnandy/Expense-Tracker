import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expense_tracker/apis/sync_service.dart';
import 'package:expense_tracker/db/db_helper.dart';
import 'package:expense_tracker/models/chartdata.dart';
import 'package:expense_tracker/models/init_shered_pref.dart';
import 'package:flutter/material.dart';

class SyncProvider extends ChangeNotifier {
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;
  String? _lastError;
  String? get lastError => _lastError;

  StreamSubscription? _connectivitySubscription;

  /// Subscribe to connectivity changes. Cancels any previous subscription first
  /// so re-login never stacks duplicate listeners.
  void startMonitoring() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        performSync();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> performSync() async {
    if (_isSyncing) return;

    final token = await InitSheredPref.instance.getToken();
    if (token == null) return;

    _isSyncing = true;
    _lastError = null;
    notifyListeners();

    try {
      final lastSyncedAt =
          await InitSheredPref.instance.getLastSyncedAt() ?? '1970-01-01 00:00:00';

      // Get locally modified records
      final modified = await DBHelper.instance.getModifiedSince(lastSyncedAt);

      // Map client fields to server fields
      final serverTransactions = modified.map((t) {
        return {
          'id': t.id,
          'amount': t.amount,
          'type': t.isExpense ? 'expense' : 'income',
          'date': '${t.date} 00:00:00',
          'note': t.purpose,
          'is_deleted': t.isDeleted,
          'updated_at': t.updatedAt,
        };
      }).toList();

      final result = await SyncService.sync(
        token: token,
        lastSyncedAt: lastSyncedAt,
        transactions: serverTransactions,
      );

      if (result['success'] == true) {
        final data = result['data'] as Map<String, dynamic>;
        final syncedAt = data['synced_at'] as String;
        final serverChanges = data['server_changes'] as Map<String, dynamic>;

        // Merge server changes into local DB
        final txns = serverChanges['transactions'] as List<dynamic>? ?? [];
        for (final txn in txns) {
          final t = txn as Map<String, dynamic>;
          if ((t['is_deleted'] ?? 0) == 1) {
            await DBHelper.instance.deleteData(t['id'] as String);
          } else {
            final serverDate = (t['date'] as String?) ?? '';
            final localDate = serverDate.length >= 10
                ? serverDate.substring(0, 10)
                : serverDate;
            await DBHelper.instance.upsertFromServer(Chartdata(
              id: t['id'] as String,
              purpose: t['note'] as String? ?? '',
              amount: (t['amount'] as num).toDouble(),
              currencySymbol: '', // preserved inside upsertFromServer if blank
              isExpense: t['type'] == 'expense',
              date: localDate,
              userId: t['user_id'] as String?,
              isDeleted: 0,
              updatedAt: t['updated_at'] as String?,
              syncedAt: syncedAt,
            ));
          }
        }

        // Mark pushed records as synced (safe: filter null ids)
        if (serverTransactions.isNotEmpty) {
          final pushedIds = modified
              .map((t) => t.id)
              .whereType<String>()
              .toList();
          if (pushedIds.isNotEmpty) {
            await DBHelper.instance.markSynced(pushedIds, syncedAt);
          }
        }

        await InitSheredPref.instance.setLastSyncedAt(syncedAt);
        await DBHelper.instance.purgeDeleted();
      } else if (result.isNotEmpty) {
        // Structured error from SyncService
        _lastError = result['message'] as String? ?? 'Sync failed';
      }
    } catch (e) {
      _lastError = e.toString();
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
}
