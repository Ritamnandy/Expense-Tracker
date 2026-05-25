# Expense Tracker — Codebase Audit (Updated)

**Date:** 2026-05-17  
**Scope:** Full-stack audit of Flutter client (Dart) + CodeIgniter 4 server (PHP)

> **Note from previous audit:** Several issues from the prior audit have been fixed:
> - Login/Register now call the API (was: dead code that just waited 3s)
> - `setTheme()` no longer calls `_prefs?.clear()` (was: wiped JWT token)
> - `.env.example` JWT_SECRET is now empty (was: well-known jwt.io example token)
> - `getSharedPref` is now a getter (was: method called without `()` — latent bug)
> - `addIncome` now captures SQLite insert ID for the local model
> - Logout button actually clears the token and navigates to login (was: no-op)
> - Splash screen routing moved to `main.dart` FutureBuilder
>
> But many old issues remain and **several new critical issues were introduced**.

---

## 🔴 CRITICAL ISSUES (Must Fix)

### 1. `MyApp` is a `StatefulWidget` without `createState` — compile error
**File:** `client/lib/main.dart:33`

```dart
class MyApp extends StatefulWidget {  // StatefulWidget requires createState()
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {  // build() belongs in State, not Widget
```

A `StatefulWidget` **must** override `createState()`. The `build()` method lives in the corresponding `State` class, not on the widget itself. This will **fail to compile**.

**Impact:** App will not compile.

---

### 2. `tokenFuture` is undefined — compile error
**File:** `client/lib/main.dart:63-64`

```dart
home: SafeArea(
  top: false,
  bottom: false,
  child: FutureBuilder(
    future: tokenFuture,  // <-- Never declared anywhere
```

`tokenFuture` is used in `FutureBuilder` but is never defined as a field, local variable, or getter. This will **fail to compile**.

**Impact:** App will not compile.

---

### 3. `double.parse()` crashes on invalid input
**Files:** `client/lib/pages/expense_page.dart:185`, `client/lib/pages/income_page.dart:182`

```dart
amount: double.parse(amountController.text),
```

The amount field validates for empty/null but never checks that the text is a valid double. Input like `"12.34.56"`, `"."`, or `"abc"` throws a `FormatException` at runtime.

**Impact:** Any non-parseable input crashes the app.

---

### 4. `(:uuidv4)` route placeholder not recognized by CI4
**File:** `server/app/Config/Routes.php:26-28, 36-38, 44-46`

CI4.7 has the `(:uuid)` placeholder but **not** `(:uuidv4)`. All routes using UUID parameters will fail to match and return 404.

```php
$routes->get('(:uuidv4)', 'AccountController::show/$1');     // 404
$routes->put('(:uuidv4)', 'AccountController::update/$1');    // 404
$routes->delete('(:uuidv4)', 'AccountController::delete/$1'); // 404
```

**Impact:** Every `show`, `update`, and `delete` endpoint returns 404.

---

### 5. `late String month` accessed when null — crash
**File:** `client/lib/screens/all_transactions.dart:38-46`

```dart
late String month;
if (selected != null) {
  month = DateFormat('yyyy-MM').format(selected);
  ...
}
context.read<ExpenseAndIncomeChart>().searchByMonth(month); // Crash if selected is null
```

If the user dismisses the year-month picker, `selected` is `null`, `month` is never assigned, and a `LateInitializationError` is thrown.

**Impact:** App crashes if user cancels month picker.

---

## 🟠 HIGH ISSUES

### 6. Sorting inside `ListView.itemBuilder` in two places (O(n² log n))
**Files:** `client/lib/screens/all_transactions.dart:103-105`, `client/lib/screens/home_screen.dart:367-369`

```dart
itemBuilder: (context, index) {
    final sortedList = [...chartProvider.list];   // Copy entire list
    sortedList.sort((a, b) => b.id!.compareTo(a.id!)); // Sort entire list
```

The entire list is sorted on every single item render. For 100 items, this runs 100 sorts. The same anti-pattern was copied to `home_screen.dart:367-369` in the latest changes.

**Impact:** Severe performance degradation as transaction count grows.

---

### 7. Missing asset files + assets section commented out
**Files:**
- `client/pubspec.yaml:80-83` — assets section is **entirely commented out**
- `client/lib/screens/hidden_drawer.dart:69` — `Image.asset("assets/images/logo.png")`
- `client/lib/screens/splash_screen.dart:22` — `Image.asset("assets/images/logo.png")`
- `client/lib/screens/all_transactions.dart:97` — `Lottie.asset("assets/images/notfound.json")`

The `pubspec.yaml` assets declaration is commented out, so **no assets are bundled** with the app. All `Image.asset` and `Lottie.asset` calls will fail at runtime with `FlutterError`.

**Impact:** `FlutterError` on launch when trying to load any asset.

---

### 8. `getToken()` adds artificial 3-second delay
**File:** `client/lib/models/init_shered_pref.dart:31`

```dart
Future<String?> getToken() async {
    await Future.delayed(Duration(seconds: 3));  // Why?
    String? value = _prefs?.getString("token");
    return value;
}
```

This adds a hard-coded 3-second delay every time the token is read. This directly impacts the `FutureBuilder` in `main.dart:64` — the splash screen is shown for at least 3 seconds before any auth decision is made.

**Impact:** 3-second artificial delay on every app launch.

---

### 9. `MyApp` build method prints width but not height
**File:** `client/lib/main.dart:38-40`

```dart
final width = MediaQuery.of(context).size.width;
final height = MediaQuery.of(context).size.height;
print(width);
// print(height) was removed — inconsistent debug logging
```

Line 39 declares `height` but it's never used. The `print(height)` from the previous version was removed while `print(width)` was kept.

---

## 🟡 MEDIUM ISSUES

### 10. `ScreenUtilInit` uses runtime dimensions as design size (no-op)
**File:** `client/lib/main.dart:42-43`

```dart
ScreenUtilInit(
    designSize: Size(width, height),  // Same as device — no scaling
```

Using the actual device dimensions means no responsive scaling occurs.

---

### 11. Dead null-check inside both `ListView.builder` instances
**Files:** `client/lib/screens/all_transactions.dart:101`, `home_screen.dart:376-378`

When `list.isEmpty`, `itemCount` is 0 and `itemBuilder` is never called. So `if (sortedList.isEmpty)` is dead code in both files.

---

### 12. `daysPassed` is actually days remaining (misnamed variable)
**File:** `client/lib/screens/home_screen.dart:70`

```dart
final daysPassed = daysInMonth - now.day;  // This is days REMAINING
// "$daysPassed days left" — label is correct, variable name is wrong
```

---

### 13. `modifiedSince()` returns soft-deleted records
**File:** `server/app/Models/AccountModel.php:49-55`, `CategoryModel.php:43-49`, `TransactionModel.php:62-68`

The sync endpoint returns records without filtering `is_deleted`. The client must manually check each record.

---

## 🔵 LOW ISSUES

### 14. Typo: `init_shered_pref.dart` should be `init_shared_pref.dart`
**File:** `client/lib/models/init_shered_pref.dart` (missing "a" in "shared")

### 15. Inconsistent error response types in `auth_services.dart`
**File:** `client/lib/apis/auth_services.dart:41,45,71,75`

Error responses return different shapes depending on code path (`error` map vs `{}` vs `{"error": e.toString()}`).

### 16. Duplicate drawer button code across 4 screens
**Files:** `home_screen.dart`, `help_screen.dart`, `notifications.dart`, `setting_screen.dart`

Identical hamburger/xmark animated drawer button copy-pasted in 4 places.

### 17. `toggleTheme` has commented-out `notifyListeners()`
**File:** `client/lib/provider/theme_provider.dart:25`

```dart
await loadTheme();
// notifyListeners();
```

`loadTheme()` calls `notifyListeners()` internally, so this is harmless dead code.

### 18. No sync data validation on server
**File:** `server/app/Controllers/Api/SyncController.php:89-124`

The `upsert()` blindly inserts whatever the client sends. No validation that `account_id` belongs to the user, amounts are positive, or dates are valid.

---

## 📊 SUMMARY (Changes from Previous Audit)

| Item | Previous Audit | Current Audit |
|------|---------------|---------------|
| Auth calls API | ❌ Dead code | ✅ **Fixed** |
| `setTheme()` clears token | ❌ `_prefs?.clear()` | ✅ **Fixed** |
| `.env.example` sample JWT | ❌ jwt.io token | ✅ **Fixed** (empty) |
| `addIncome` missing DB id | ❌ No id capture | ✅ **Fixed** |
| Logout button | ❌ No-op | ✅ **Fixed** |
| Splash routing | ❌ Direct navigate | ✅ **Fixed** (FutureBuilder) |
| `MyApp` missing `createState` | ✅ N/A | ❌ **NEW — compile error** |
| `tokenFuture` undefined | ✅ N/A | ❌ **NEW — compile error** |
| `getToken()` 3s delay | ✅ No delay | ❌ **NEW — 3s wait** |
| Sort in `home_screen` builder | ❌ Not present | ❌ **NEW — copied pattern** |
| Assets section commented out | ✅ Declared | ❌ **NEW — no assets** |
| `double.parse()` crash | ❌ Unfixed | ❌ **Still broken** |
| `(:uuidv4)` routes 404 | ❌ Unfixed | ❌ **Still broken** |
| `late` month crash | ❌ Unfixed | ❌ **Still broken** |
| Sort in `itemBuilder` | ❌ Unfixed | ❌ **Still broken (x2)** |

| Severity | Count |
|----------|-------|
| 🔴 Critical | 5 |
| 🟠 High | 4 |
| 🟡 Medium | 4 |
| 🔵 Low | 5 |
| **Total** | **18** |

### Top 3 must-fix items:
1. **`MyApp` missing `createState`** — won't compile
2. **`tokenFuture` undefined** — won't compile
3. **Assets section commented out** — no assets bundled, FlutterError at runtime
