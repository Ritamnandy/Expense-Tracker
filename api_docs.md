# Expense Tracker API & Database Schema Documentation

This document outlines the database schema and RESTful API endpoints for the Expense Tracker application. It is designed with an **Offline-First** architecture in mind, using SQLite for local mobile/web storage and an SQL database (e.g., PostgreSQL or MySQL) for online cloud synchronization.

## Database Schema Design Considerations

To support seamless offline-to-online synchronization, we use **UUIDs (v4)** for all primary keys. This prevents primary key collisions when creating records locally and syncing them to the cloud later. All models include `is_deleted` for soft-deletes and `synced_at` to track synchronization state.

### 1. User
Stores user authentication and profile details (primarily for the online database).
* `id` (UUID, Primary Key)
* `email` (String, Unique)
* `password_hash` (String)
* `first_name` (String, Nullable)
* `last_name` (String, Nullable)
* `created_at` (Timestamp)
* `updated_at` (Timestamp)

### 2. Account (Wallets/Banks)
Sources of funds or places where money is stored.
* `id` (UUID, Primary Key)
* `user_id` (UUID, Foreign Key -> User.id)
* `name` (String) - e.g., "Cash", "Bank of America", "Credit Card"
* `type` (Enum: `cash`, `bank`, `credit`)
* `balance` (Decimal/Real) - Current balance
* `currency` (String) - e.g., "USD", "EUR"
* `created_at` (Timestamp)
* `updated_at` (Timestamp)
* `is_deleted` (Boolean, Default: false)
* `synced_at` (Timestamp, Nullable)

### 3. Category
Categories for classifying transactions.
* `id` (UUID, Primary Key)
* `user_id` (UUID, Foreign Key -> User.id)
* `name` (String) - e.g., "Groceries", "Salary"
* `type` (Enum: `income`, `expense`)
* `icon` (String, Nullable) - Icon identifier or URL
* `color` (String, Nullable) - Hex color code
* `created_at` (Timestamp)
* `updated_at` (Timestamp)
* `is_deleted` (Boolean, Default: false)
* `synced_at` (Timestamp, Nullable)

### 4. Transaction
The core record of money moving in or out.
* `id` (UUID, Primary Key)
* `user_id` (UUID, Foreign Key -> User.id)
* `account_id` (UUID, Foreign Key -> Account.id)
* `category_id` (UUID, Foreign Key -> Category.id)
* `amount` (Decimal/Real) - Absolute value
* `type` (Enum: `income`, `expense`, `transfer`)
* `date` (Timestamp) - When the transaction occurred
* `note` (Text, Nullable)
* `created_at` (Timestamp)
* `updated_at` (Timestamp)
* `is_deleted` (Boolean, Default: false)
* `synced_at` (Timestamp, Nullable)

---

## API Endpoints

All endpoints (except auth) require an `Authorization: Bearer <token>` header.

**Standard Response Format:**
```json
{
  "success": true,
  "data": { ... },
  "message": "Optional message",
  "error": null
}
```

### Authentication
* **`POST /api/v1/auth/register`** - Register a new user.
* **`POST /api/v1/auth/login`** - Authenticate and receive a JWT token.
* **`GET /api/v1/auth/me`** - Get current user profile.

### Synchronization (Offline-First)
Instead of calling individual CRUD endpoints for every local change, an offline-first app typically batches changes and uses a master sync endpoint to save battery, bandwidth, and handle intermittent connectivity.

* **`POST /api/v1/sync`**
  * **Description**: Pushes local changes to the server and pulls the latest server changes.
  * **Request Body**:
    ```json
    {
      "last_synced_at": "2026-05-01T12:00:00Z",
      "changes": {
        "accounts": [ { /* ...changed account objects... */ } ],
        "categories": [ { /* ...changed category objects... */ } ],
        "transactions": [ { /* ...changed transaction objects... */ } ]
      }
    }
    ```
  * **Response**: Returns objects that were modified on the server since `last_synced_at` to update the local SQLite database.

### Accounts CRUD (Standard REST)
* **`GET /api/v1/accounts`** - List all active accounts.
* **`POST /api/v1/accounts`** - Create a new account.
* **`GET /api/v1/accounts/:id`** - Get account details.
* **`PUT /api/v1/accounts/:id`** - Update an account.
* **`DELETE /api/v1/accounts/:id`** - Soft delete an account.

### Categories CRUD (Standard REST)
* **`GET /api/v1/categories`** - List all active categories.
* **`POST /api/v1/categories`** - Create a new category.
* **`PUT /api/v1/categories/:id`** - Update a category.
* **`DELETE /api/v1/categories/:id`** - Soft delete a category.

### Transactions CRUD (Standard REST)
* **`GET /api/v1/transactions`** - List transactions.
  * *Query Params:* `?start_date=2026-05-01&end_date=2026-05-31&account_id=...&type=expense`
* **`POST /api/v1/transactions`** - Create a new transaction.
* **`GET /api/v1/transactions/:id`** - Get transaction details.
* **`PUT /api/v1/transactions/:id`** - Update a transaction.
* **`DELETE /api/v1/transactions/:id`** - Soft delete a transaction.
