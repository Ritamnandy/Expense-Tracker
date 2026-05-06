# Expense Tracker — Backend Server

> **Stack**: PHP 8.1+ · CodeIgniter 4 · MySQL 8 · Custom HS256 JWT

This is the REST API backend for the Expense Tracker offline-first Android application.  
It handles user authentication, data persistence, and bi-directional sync with the mobile client.

---

## ✨ App Features

A complete personal finance manager built for real-world, everyday use — works fully offline and syncs when connected.

### 💰 Transaction Management
- Record **Income**, **Expense**, and **Transfer** transactions
- Each transaction has an amount, date, optional note, account, and category
- Filter transactions by **date range**, **account**, or **type**
- **Soft-delete** support — deleted records are recoverable and sync correctly to all devices
- Real-time **summary** on every list response: total income, total expense, and safe-to-spend balance

### 🏦 Multiple Accounts
- Support for multiple wallet types: **Cash**, **Bank**, and **Credit Card**
- Each account has a name, balance, and currency (e.g. `INR`, `USD`)
- Per-user account isolation — users only see their own accounts
- A **"Main Wallet"** account is created automatically on registration

### 🏷️ Custom Categories
- Create fully custom categories with a **name**, **type** (income/expense), **icon**, and **color**
- Categories are personal — each user manages their own
- 3 default categories (**Salary**, **Groceries**, **Utilities**) are seeded on first registration
- Transfer transactions intentionally do not require a category

### 🔄 Offline-First Sync
- The app works **100% offline** using local SQLite storage on the device
- When internet is available, a single `POST /sync` call handles everything:
  - **Push**: sends all locally created/changed/deleted records to the server
  - **Pull**: receives all server-side changes since the last sync
- Sync is **atomic** — if anything fails, nothing is partially saved
- **Conflict resolution**: server wins when both sides changed the same record (based on `updated_at`)
- Uses **UUID v4** primary keys generated on-device to prevent ID collisions

### 🔐 Authentication & Security
- **JWT-based authentication** (HS256, no external library)
- Tokens are valid for **7 days**
- Passwords hashed with **bcrypt** (`PASSWORD_BCRYPT`)
- Every data endpoint is user-scoped — users can never read or modify another user's data
- UUIDs are cryptographically generated using `random_bytes()`

### 🌐 API Design
- Clean **RESTful API** with a consistent JSON response envelope on every endpoint
- API versioned under `/api/v1` for future compatibility
- Full **CORS support** — works with Android native clients, Flutter, and web clients
- Meaningful HTTP status codes (`200`, `201`, `401`, `404`, `409`, `422`, `500`)
- Validation errors return field-level details so the client can show precise messages

### 📊 Dashboard Summary *(via API)*
- `GET /transactions` always returns a **summary block** alongside the list:
  - Total **income**
  - Total **expense**
  - **Safe to spend** (income − expense)
- Filterable by date range to power monthly/weekly dashboard views

### 🔮 Planned / Suggested Future Features
- [ ] **Budget limits** per category — alert when spending exceeds a set amount
- [ ] **Recurring transactions** — auto-generate weekly/monthly entries (rent, salary, subscriptions)
- [ ] **Transfer between accounts** — track money moved between wallets with balance updates
- [ ] **Multi-currency support** — per-transaction currency with conversion rates
- [ ] **Spending analytics** — pie chart data by category, trend graphs over time
- [ ] **Export to CSV / PDF** — download transaction history
- [ ] **Push notifications** — remind user to log daily expenses
- [ ] **Token refresh** — short-lived access tokens + refresh token endpoint for better security
- [ ] **Profile management** — update name, email, password via API
- [ ] **Account balance auto-calculation** — derive balance from transaction history instead of manual entry

---

## 📋 Prerequisites

Make sure the following are installed before you begin:

| Tool | Minimum Version | Check |
|---|---|---|
| PHP | 8.1 | `php -v` |
| Composer | 2.x | `composer --version` |
| MySQL | 8.0 | `mysql --version` |
| Git | Any | `git --version` |

**Required PHP Extensions** (most are enabled by default):

```
- intl
- mbstring
- json
- mysqlnd
- curl
- xml
```

Check your active extensions:
```bash
php -m
```

---

## ⚙️ Setup — Step by Step

### Step 1 — Clone the Repository

```bash
git clone https://github.com/your-username/expense-tracker.git
cd expense-tracker/server
```

---

### Step 2 — Install PHP Dependencies

```bash
composer install
```

> This installs CodeIgniter 4 and all dependencies listed in `composer.json` into the `vendor/` folder.

---

### Step 3 — Configure Environment Variables

Copy the example env file:

```bash
cp .env.example .env
```

Open `.env` and fill in your values:

```dotenv
# Set to 'production' when deploying live
CI_ENVIRONMENT = development

# Your MySQL database credentials
database.default.hostname = localhost
database.default.database = expense_db
database.default.username = root
database.default.password = YOUR_DB_PASSWORD
database.default.DBDriver = MySQLi
database.default.port     = 3306

# JWT Secret — generate a strong random key:
#   openssl rand -hex 32
JWT_SECRET = your_very_long_random_secret_here
```

> ⚠️ **Never commit `.env` to Git.** It is already listed in `.gitignore`.

---

### Step 4 — Create the Database

Log in to MySQL and create the database:

```sql
CREATE DATABASE expense_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Or via CLI:

```bash
mysql -u root -p -e "CREATE DATABASE expense_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

---

### Step 5 — Run Migrations

This creates all 4 tables: `users`, `accounts`, `categories`, `transactions`.

```bash
php spark migrate
```

Expected output:
```
Running: 2026-05-01-000001_CreateUsersTable
Running: 2026-05-01-000002_CreateAccountsTable
Running: 2026-05-01-000003_CreateCategoriesTable
Running: 2026-05-01-000004_CreateTransactionsTable
```

> To roll back all migrations (drop tables):
> ```bash
> php spark migrate:rollback
> ```

---

### Step 6 — Start the Development Server

```bash
php spark serve
```

The server starts at:
```
http://localhost:8080
```

To bind to a specific IP (so Android devices on the same Wi-Fi can reach it):

```bash
php spark serve --host 0.0.0.0 --port 8080
```

Then on your Android device, use your machine's local IP:
```
http://192.168.x.x:8080/api/v1
```

> Find your local IP:
> - **Windows**: `ipconfig` → look for IPv4 Address
> - **Linux/macOS**: `ip addr` or `ifconfig`

---

## 🗂️ Project Structure

```
server/
├── app/
│   ├── Config/
│   │   ├── Cors.php          # CORS settings (origins, headers, methods)
│   │   ├── Filters.php       # Filter aliases and global filter config
│   │   └── Routes.php        # All API route definitions
│   │
│   ├── Controllers/
│   │   └── Api/
│   │       ├── BaseApiController.php   # Shared helpers (success/error/uuid)
│   │       ├── AuthController.php      # Register, Login, Me
│   │       ├── AccountController.php   # Accounts CRUD
│   │       ├── CategoryController.php  # Categories CRUD
│   │       ├── TransactionController.php # Transactions CRUD
│   │       └── SyncController.php      # Offline-first sync endpoint
│   │
│   ├── Database/
│   │   └── Migrations/       # Table definitions (run via php spark migrate)
│   │
│   ├── Filters/
│   │   └── JwtFilter.php     # Validates Authorization: Bearer <token>
│   │
│   ├── Libraries/
│   │   └── JwtHelper.php     # Minimal HS256 JWT encode/decode (no external lib)
│   │
│   └── Models/
│       ├── UserModel.php
│       ├── AccountModel.php
│       ├── CategoryModel.php
│       └── TransactionModel.php
│
├── public/                   # Web root — point your web server here
├── writable/                 # Logs, cache, sessions (auto-generated, git-ignored)
├── .env                      # Your local config (NOT in Git)
├── .env.example              # Template — safe to commit
└── composer.json
```

---

## 🌐 API Overview

All endpoints are prefixed with `/api/v1`.

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/auth/register` | ❌ | Register a new user |
| `POST` | `/auth/login` | ❌ | Login, receive JWT token |
| `GET` | `/auth/me` | ✅ | Get current user profile |
| `POST` | `/sync` | ✅ | Push local changes + pull server changes |
| `GET` | `/accounts` | ✅ | List all accounts |
| `POST` | `/accounts` | ✅ | Create an account |
| `GET` | `/accounts/:id` | ✅ | Get one account |
| `PUT` | `/accounts/:id` | ✅ | Update an account |
| `DELETE` | `/accounts/:id` | ✅ | Soft-delete an account |
| `GET` | `/categories` | ✅ | List all categories |
| `POST` | `/categories` | ✅ | Create a category |
| `GET` | `/categories/:id` | ✅ | Get one category |
| `PUT` | `/categories/:id` | ✅ | Update a category |
| `DELETE` | `/categories/:id` | ✅ | Soft-delete a category |
| `GET` | `/transactions` | ✅ | List transactions (filterable) |
| `POST` | `/transactions` | ✅ | Create a transaction |
| `GET` | `/transactions/:id` | ✅ | Get one transaction |
| `PUT` | `/transactions/:id` | ✅ | Update a transaction |
| `DELETE` | `/transactions/:id` | ✅ | Soft-delete a transaction |

> For full request/response examples, see **[`../api_docs.md`](../api_docs.md)**.

---

## 🔑 JWT Authentication

- Tokens are generated on **register** and **login**.
- Validity: **7 days** from issue time.
- Send as a header on every protected request:
  ```
  Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
  ```
- Algorithm: **HS256** (no external library — custom `JwtHelper`).
- Secret is read from `JWT_SECRET` in your `.env`.

---

## 🔄 Useful `spark` Commands

```bash
# Start dev server
php spark serve

# Start on a specific host/port
php spark serve --host 0.0.0.0 --port 8080

# Run all pending migrations
php spark migrate

# Rollback all migrations (drops tables)
php spark migrate:rollback

# View all registered routes
php spark routes

# Clear application cache
php spark cache:clear

# Check CodeIgniter version
php spark --version
```

---

## 🚀 Production Deployment Notes

1. **Point your web server (Apache/Nginx) document root to `/server/public/`** — never expose the project root.
2. **Enable HTTPS** and set `CI_ENVIRONMENT = production` in `.env`.
3. **Re-enable `forcehttps`** in `app/Config/Filters.php` once SSL is configured:
   ```php
   'before' => ['forcehttps', 'pagecache'],
   ```
4. **Restrict CORS origins** in `app/Config/Cors.php` from `'*'` to your specific domain.
5. **Generate a strong JWT secret**: `openssl rand -hex 32`
6. Make sure `writable/` is writable by the web server process:
   ```bash
   chmod -R 775 writable/
   ```

### Apache — `.htaccess` (already in `public/`)
The `public/.htaccess` included with CodeIgniter handles URL rewriting automatically.  
Make sure `mod_rewrite` is enabled:
```bash
a2enmod rewrite
```

### Nginx — Sample Config

```nginx
server {
    listen 80;
    server_name yourdomain.com;
    root /var/www/expense-tracker/server/public;

    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

---

## 🐛 Troubleshooting

| Problem | Fix |
|---|---|
| `Class 'Config\Database' not found` | Run `composer install` |
| `Unable to connect to database` | Check hostname, username, password, and database name in `.env` |
| `JWT_SECRET is not configured` | Make sure `.env` exists and `JWT_SECRET` is set (not commented out) |
| `404 on all API routes` | Confirm `mod_rewrite` is enabled (Apache) or `try_files` is set (Nginx) |
| Android can't reach the server | Use `--host 0.0.0.0` and your machine's LAN IP, not `localhost` |
| `403 Forbidden` on writable/ | Run `chmod -R 775 writable/` |
| Migration fails | Ensure the database exists and credentials in `.env` are correct |
| `forcehttps` redirect loop | Comment out `forcehttps` in `Config/Filters.php` for local dev |
