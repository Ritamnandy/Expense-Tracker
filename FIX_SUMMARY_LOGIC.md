# Safe-to-Spend Summary Logic Fix

## Problem

The home screen's summary (income, expense, safe-to-spend, circular progress bar, days left) is unreliable because:

1. **Scope is wrong** — it calculates from `chartProvider.list` which contains _all_ transactions. The "X days left" label implies a monthly view, but the numbers aren't scoped to the current month.

2. **Date picker breaks it** — tapping the date in the app bar calls `searchByDate()`, which replaces `chartProvider.list` with only that single day's transactions. The summary then shows meaningless numbers for one day.

3. **No way to reset** — only pull-to-refresh restores the full list.

## Proposed Fix

### Goal

- Summary always reflects the **current month** regardless of date filter
- Date picker only filters the **recent transactions list** below the summary
- "Safe to Spend" and "X days left" are consistent

### Changes

**`client/lib/screens/home_screen.dart`** — 3 changes:

1. **`initState`**: Load current month data instead of all data

   ```dart
   // Before:
   context.read<ExpenseAndIncomeChart>().loadData();
   // After:
   final now = DateTime.now();
   final month = '${now.year}-${_pad(now.month)}';
   context.read<ExpenseAndIncomeChart>().searchByMonth(month);
   ```

2. **`build` method**: Read list but also compute a _separate_ monthly summary
   - Keep `chartProvider.list` for the recent transactions ListView (already filtered by the date picker)
   - Fetch a separate monthly total for the summary section (independent of the date picker filter)

3. **`_selectTime`**: Remove `_searchbydate()` call that filters the provider; instead, just update the `time` label visually but filter the list locally
   ```dart
   // Before:
   _searchbydate(datetime);
   setState(() { time = ... });
   // After:
   setState(() { time = ... });
   // Only filter the ListView, not the summary
   ```

**`client/lib/provider/add_expense_chart.dart`** — 1 addition:

4. Add a method to get monthly totals that doesn't replace the main list:
   ```dart
   Future<double> monthlyIncome(int year, int month) async { ... }
   Future<double> monthlyExpense(int year, int month) async { ... }
   ```

### Result

| Scenario              | Summary                   | Transaction List          |
| --------------------- | ------------------------- | ------------------------- |
| App opens             | Current month summary     | All recent transactions   |
| User taps date picker | Still shows current month | Filtered to selected date |
| Pull to refresh       | Current month summary     | All recent transactions   |

### No new files needed — only 2 existing files change.
