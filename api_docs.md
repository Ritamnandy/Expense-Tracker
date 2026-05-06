# Expense Tracker — API Reference
**Version 2.0** · Last updated: 2026-05-06 · Server: CodeIgniter 4 · Auth: JWT Bearer Token

> **For the Android (client) developer.**  
> This document covers every endpoint you need to integrate with.  
> The backend is already live — just configure your base URL and follow the patterns below.

---

## 📌 Quick-Start Checklist

- [ ] Set your `BASE_URL` (e.g. `http://192.168.x.x:8080/api/v1`)
- [ ] Call `POST /auth/register` or `POST /auth/login` to get your JWT token
- [ ] Store the token securely (e.g., Flutter `flutter_secure_storage`)
- [ ] Attach it as `Authorization: Bearer <token>` on every protected request
- [ ] For offline-first sync, use `POST /sync` — not the individual CRUD endpoints

---

## 🌐 Base URL

```
http://<SERVER_IP>:<PORT>/api/v1
```

All responses are **JSON**. All request bodies must be `Content-Type: application/json`.

---

## 📦 Standard Response Envelope

Every endpoint returns this same wrapper:

```json
{
  "success": true,
  "message": "Human-readable message",
  "data": { },
  "error": null
}
```

| Field | Type | Description |
|---|---|---|
| `success` | `bool` | `true` on success, `false` on failure |
| `message` | `string` | Readable status message |
| `data` | `object\|array\|null` | The actual payload |
| `error` | `object\|null` | Validation errors on `422`, otherwise `null` |

---

## 🔒 Authentication

All endpoints **except** `/auth/register` and `/auth/login` require this header:

```
Authorization: Bearer <your_jwt_token>
```

JWT tokens are valid for **7 days**. When expired, the response is:
```json
{ "success": false, "message": "Invalid or expired token." }
```
→ **Action**: Call `/auth/login` again to get a fresh token.

---

## 👤 Auth Endpoints

### `POST /auth/register`
Create a new user account. Returns a JWT token immediately — no need to login separately after registering.

**Request Body:**
```json
{
  "email":      "user@example.com",
  "password":   "mypassword",
  "first_name": "Ravi",
  "last_name":  "Kumar"
}
```
> `first_name` and `last_name` are optional.

**Success Response** `201 Created`:
```json
{
  "success": true,
  "message": "Registration successful.",
  "data": {
    "token": "eyJ..."
  }
}
```

**Error — Email already taken** `409 Conflict`:
```json
{ "success": false, "message": "Email already registered." }
```

**Error — Validation failed** `422 Unprocessable Entity`:
```json
{
  "success": false,
  "message": "Validation failed.",
  "error": { "email": "The email field must contain a valid email address." }
}
```

> 🟡 **Note**: On successful registration, 3 default categories (Salary, Groceries, Utilities) and 1 default account (Main Wallet / INR) are created automatically.

---

### `POST /auth/login`
Authenticate and get a JWT token.

**Request Body:**
```json
{
  "email":    "user@example.com",
  "password": "mypassword"
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "message": "Login successful.",
  "data": {
    "token": "eyJ...",
    "user": {
      "id":         "uuid",
      "email":      "user@example.com",
      "first_name": "Ravi",
      "last_name":  "Kumar"
    }
  }
}
```

**Error — Wrong credentials** `401 Unauthorized`:
```json
{ "success": false, "message": "Invalid credentials." }
```

---

### `GET /auth/me` 🔒
Get the currently logged-in user's profile.

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "id":         "uuid",
    "email":      "user@example.com",
    "first_name": "Ravi",
    "last_name":  "Kumar",
    "created_at": "2026-05-06 10:00:00",
    "updated_at": "2026-05-06 10:00:00"
  }
}
```

---

## 🔄 Sync Endpoint (Offline-First Core)

> **Use this instead of individual CRUD endpoints when syncing offline changes.**  
> This is a single round-trip that pushes your local SQLite changes and pulls any server changes back.

### `POST /sync` 🔒

**How it works:**
1. You send all locally created/updated/deleted records since the last sync.
2. The server upserts them atomically (all-or-nothing — if anything fails, nothing is saved).
3. The server returns all records it modified since your `last_synced_at`.
4. You merge the server response into your local SQLite.

**Request Body:**
```json
{
  "last_synced_at": "2026-05-05 10:00:00",
  "changes": {
    "accounts": [
      {
        "id":         "local-uuid",
        "name":       "Main Wallet",
        "type":       "cash",
        "balance":    5000.00,
        "currency":   "INR",
        "is_deleted": 0,
        "synced_at":  null,
        "updated_at": "2026-05-06 08:00:00"
      }
    ],
    "categories": [ ],
    "transactions": [
      {
        "id":          "local-uuid",
        "account_id":  "account-uuid",
        "category_id": "category-uuid",
        "amount":      250.00,
        "type":        "expense",
        "date":        "2026-05-06 09:30:00",
        "note":        "Coffee",
        "is_deleted":  0,
        "synced_at":   null,
        "updated_at":  "2026-05-06 09:30:00"
      }
    ]
  }
}
```

> - `last_synced_at`: Use `"1970-01-01 00:00:00"` for first-time sync (fetches everything).
> - Any of the 3 arrays can be empty `[]` if there are no changes for that type.
> - `category_id` may be `null` for `transfer` type transactions.

**Success Response** `200 OK`:
```json
{
  "success": true,
  "message": "Sync complete.",
  "data": {
    "synced_at": "2026-05-06 12:00:00",
    "server_changes": {
      "accounts":     [ /* ...account objects modified since last_synced_at... */ ],
      "categories":   [ /* ...category objects... */ ],
      "transactions": [ /* ...transaction objects... */ ]
    }
  }
}
```

> Save `data.synced_at` locally. Pass it as `last_synced_at` in your next sync call.

**Error — Server write failed** `500 Internal Server Error`:
```json
{
  "success": false,
  "message": "Sync failed due to a server error. No changes were saved. Please retry."
}
```

---

## 🏦 Accounts

### Data Model

| Field | Type | Notes |
|---|---|---|
| `id` | `string (UUID)` | Generate on device before syncing |
| `user_id` | `string (UUID)` | Set by server, ignore on client |
| `name` | `string` | e.g. "Main Wallet", "HDFC Bank" |
| `type` | `enum` | `cash` · `bank` · `credit` |
| `balance` | `decimal` | Current balance |
| `currency` | `string` | e.g. `INR`, `USD` |
| `is_deleted` | `int` | `0` = active, `1` = deleted |
| `synced_at` | `datetime\|null` | Last sync timestamp |
| `created_at` | `datetime` | Set by server |
| `updated_at` | `datetime` | Set by server |

### `GET /accounts` 🔒
Returns all non-deleted accounts for the logged-in user.

**Response `data`**: Array of account objects.

---

### `POST /accounts` 🔒

**Request Body:**
```json
{
  "name":     "HDFC Savings",
  "type":     "bank",
  "balance":  10000.00,
  "currency": "INR"
}
```
> `balance` defaults to `0`, `currency` defaults to `INR`.

**Response**: `201 Created` with the full created account object.

---

### `GET /accounts/:id` 🔒
Get a single account by UUID.

---

### `PUT /accounts/:id` 🔒
Update an account. Send only the fields you want to change.

**Request Body** (all optional):
```json
{
  "name":     "Updated Name",
  "type":     "credit",
  "balance":  8000.00,
  "currency": "USD"
}
```

---

### `DELETE /accounts/:id` 🔒
Soft-deletes the account (`is_deleted = 1`). The record is NOT permanently deleted — it will appear in sync responses so the client can mark it deleted in local SQLite too.

---

## 🏷️ Categories

### Data Model

| Field | Type | Notes |
|---|---|---|
| `id` | `string (UUID)` | |
| `name` | `string` | e.g. "Groceries", "Salary" |
| `type` | `enum` | `income` · `expense` |
| `icon` | `string\|null` | Icon name/identifier (e.g. Material icon key) |
| `color` | `string\|null` | Hex color code e.g. `#FF644B` |
| `is_deleted` | `int` | `0` = active, `1` = deleted |

### `GET /categories` 🔒
Returns all non-deleted categories for the logged-in user.

### `POST /categories` 🔒
```json
{
  "name":  "Transport",
  "type":  "expense",
  "icon":  "directions_car",
  "color": "#4A90E2"
}
```

### `GET /categories/:id` 🔒
Get a single category by UUID.

### `PUT /categories/:id` 🔒
Update a category. All fields optional.

### `DELETE /categories/:id` 🔒
Soft-delete a category.

---

## 💸 Transactions

### Data Model

| Field | Type | Notes |
|---|---|---|
| `id` | `string (UUID)` | |
| `account_id` | `string (UUID)` | Required |
| `category_id` | `string (UUID)\|null` | **Null is allowed for `transfer` type** |
| `amount` | `decimal` | Always a positive number |
| `type` | `enum` | `income` · `expense` · `transfer` |
| `date` | `datetime` | Format: `YYYY-MM-DD HH:MM:SS` |
| `note` | `string\|null` | Optional description |
| `is_deleted` | `int` | `0` = active, `1` = deleted |

### `GET /transactions` 🔒
Returns all non-deleted transactions, sorted newest first.

**Optional Query Params:**
```
?start_date=2026-05-01 00:00:00
&end_date=2026-05-31 23:59:59
&account_id=<uuid>
&type=expense
```

**Response `data`:**
```json
{
  "transactions": [ /* ...transaction objects... */ ],
  "summary": {
    "income":        15000.00,
    "expense":       4200.00,
    "safe_to_spend": 10800.00
  }
}
```

---

### `POST /transactions` 🔒

```json
{
  "account_id":  "account-uuid",
  "category_id": "category-uuid",
  "amount":      500.00,
  "type":        "expense",
  "date":        "2026-05-06 14:30:00",
  "note":        "Lunch"
}
```

> ⚠️ **For `transfer` type**: `category_id` can be omitted or `null`.

**Response**: `201 Created` with the full transaction object.

---

### `GET /transactions/:id` 🔒
Get a single transaction by UUID.

### `PUT /transactions/:id` 🔒
Update a transaction. All fields optional.

### `DELETE /transactions/:id` 🔒
Soft-delete a transaction.

---

## ❗ HTTP Status Code Reference

| Code | Meaning | When you see it |
|---|---|---|
| `200 OK` | Success | GET, PUT, DELETE success |
| `201 Created` | Resource created | POST success |
| `401 Unauthorized` | Auth failed | Missing/expired/invalid JWT |
| `404 Not Found` | Not found | Wrong ID or deleted resource |
| `409 Conflict` | Duplicate | Email already registered |
| `422 Unprocessable Entity` | Validation error | Bad input data — check `error` field |
| `500 Internal Server Error` | Server error | Sync transaction failure |

---

## 💡 Offline-First Flow (Recommended)

```
App starts
│
├─ Load all data from local SQLite (instant, works offline)
│
└─ Try to sync (if internet available)
     │
     └─ POST /sync
          ├─ Push: all local records with is_deleted=0 or changed since last sync
          └─ Pull: merge server_changes into SQLite
               └─ Save synced_at for next sync
```

**Key rules for the client:**
1. Generate UUIDs on device (use `uuid` package — v4 format).
2. Every create/update/delete in SQLite → mark that record as "pending sync".
3. On sync success → update local `synced_at` for all pushed records.
4. On sync failure → keep pending flag, retry next time.
5. Server wins on conflict (newer `updated_at` takes precedence).
