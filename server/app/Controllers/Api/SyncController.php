<?php

namespace App\Controllers\Api;

use App\Models\AccountModel;
use App\Models\CategoryModel;
use App\Models\TransactionModel;
use CodeIgniter\HTTP\ResponseInterface;

/**
 * Handles offline → online sync in a single round-trip.
 *
 * Flow:
 *   1. Client POSTs local changes (created/updated/deleted records).
 *   2. Server upserts each record (insert or update based on ID existence).
 *   3. Server returns all records modified on the server since last_synced_at.
 *   4. Client merges the server response into local SQLite.
 */
class SyncController extends BaseApiController
{
    // ── POST /api/v1/sync ─────────────────────────────────────────────────

    public function sync()
    {
        $userId     = $this->userId();
        $body       = $this->request->getJSON(true);
        $since      = $body['last_synced_at'] ?? '1970-01-01 00:00:00';
        $changes    = $body['changes'] ?? [];

        $accountModel     = new AccountModel();
        $categoryModel    = new CategoryModel();
        $transactionModel = new TransactionModel();

        // ── 1. Push local changes to server ──────────────────────────────

        if (! empty($changes['accounts'])) {
            $this->upsert($accountModel, $changes['accounts'], $userId, [
                'name', 'type', 'balance', 'currency', 'is_deleted', 'synced_at',
            ]);
        }

        if (! empty($changes['categories'])) {
            $this->upsert($categoryModel, $changes['categories'], $userId, [
                'name', 'type', 'icon', 'color', 'is_deleted', 'synced_at',
            ]);
        }

        if (! empty($changes['transactions'])) {
            $this->upsert($transactionModel, $changes['transactions'], $userId, [
                'account_id', 'category_id', 'amount', 'type', 'date', 'note',
                'is_deleted', 'synced_at',
            ]);
        }

        // ── 2. Pull server changes since last_synced_at ───────────────────

        $now = date('Y-m-d H:i:s');

        return $this->success([
            'synced_at'    => $now,
            'server_changes' => [
                'accounts'     => $accountModel->modifiedSince($userId, $since),
                'categories'   => $categoryModel->modifiedSince($userId, $since),
                'transactions' => $transactionModel->modifiedSince($userId, $since),
            ],
        ], 'Sync complete.');
    }

    // ── Upsert Helper ─────────────────────────────────────────────────────

    /**
     * Insert or update a record.
     * If the record already exists on the server, only allowed fields are updated.
     */
    private function upsert($model, array $records, string $userId, array $updatableFields): void
    {
        foreach ($records as $record) {
            if (empty($record['id'])) {
                continue;
            }

            $existing = $model->find($record['id']);

            if ($existing) {
                // Only update if the incoming record is newer
                if (
                    isset($record['updated_at']) &&
                    isset($existing['updated_at']) &&
                    $record['updated_at'] <= $existing['updated_at']
                ) {
                    continue;
                }

                $updateData = [];
                foreach ($updatableFields as $field) {
                    if (array_key_exists($field, $record)) {
                        $updateData[$field] = $record[$field];
                    }
                }

                if (! empty($updateData)) {
                    $model->update($record['id'], $updateData);
                }
            } else {
                // New record — insert it, forcing user_id for security
                $record['user_id'] = $userId;
                $model->insert($record);
            }
        }
    }
}
