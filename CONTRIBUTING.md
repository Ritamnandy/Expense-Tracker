# Contributing to Expense Tracker

Welcome! This guide is for developers (like your project partner) who want to contribute to the **Expense Tracker** application. It covers everything from getting the code to submitting your changes for review.

---

## 1. 🍴 Fork the Repository

Since you will be contributing to the main project, it's best practice to work from your own copy (a "fork").

1. Go to the original repository page on GitHub: `https://github.com/Souma061/Expense-Tracker`
2. In the top-right corner of the page, click the **Fork** button.
3. Choose your GitHub account as the destination.
4. You now have a complete copy of the repository under your own GitHub account: `https://github.com/your-username/Expense-Tracker`.

---

## 2. 💻 Clone Your Fork

Now, bring the code down to your local computer.

1. Open your terminal or command prompt.
2. Copy the clone URL from *your fork's* GitHub page (click the green **Code** button).
3. Run the following command:
   ```bash
   git clone https://github.com/your-username/Expense-Tracker.git
   ```
4. Navigate into the project folder:
   ```bash
   cd Expense-Tracker
   ```

---

## 3. 🔗 Connect to the Original Repository (Upstream)

To keep your fork up-to-date with the main project, you need to add the original repository as an "upstream" remote.

1. Run this command to add the upstream remote:
   ```bash
   git remote add upstream https://github.com/Souma061/Expense-Tracker.git
   ```
2. Verify that both your fork (`origin`) and the main repo (`upstream`) are configured:
   ```bash
   git remote -v
   ```
   *You should see two `origin` lines (your fork) and two `upstream` lines (the main repo).*

---

## 4. 🌿 Create a Branch for Your Work

**Never work directly on the `main` branch.** Always create a new branch for every feature or bug fix.

1. First, make sure your `main` branch is up-to-date with the upstream repository:
   ```bash
   git checkout main
   git fetch upstream
   git merge upstream/main
   ```
2. Create and switch to a new branch for your feature. Name it something descriptive:
   ```bash
   git checkout -b feature/flutter-ui-setup
   # or
   git checkout -b fix/login-button-bug
   ```

---

## 5. 🛠️ Make Your Changes

Now you can open the code in your editor (like VS Code or Android Studio) and start working.

- **For the Server (CodeIgniter 4):** Go into the `server/` directory. See `server/README.md` for setup instructions.
- **For the Client (Flutter):** Go into the `client/` directory. Run `flutter pub get` and start coding. See `api_docs.md` for backend integration.

### Committing Your Work
As you make progress, save your changes with clear commit messages.

1. Stage your changed files:
   ```bash
   git add .
   ```
2. Commit with a descriptive message:
   ```bash
   git commit -m "Add UI for the transactions dashboard"
   ```

---

## 6. 🔄 Keep Your Branch Updated

While you are working, other changes might be merged into the main project. To avoid conflicts later, frequently update your branch.

1. Fetch the latest changes from upstream:
   ```bash
   git fetch upstream
   ```
2. Rebase (or merge) those changes into your current branch:
   ```bash
   git rebase upstream/main
   ```
   *(If there are conflicts, Git will pause and ask you to resolve them in your editor before continuing).*

---

## 7. 🚀 Push to Your Fork

Once your feature is complete and working locally, push it to your GitHub fork.

```bash
git push origin feature/flutter-ui-setup
```

---

## 8. 📩 Create a Pull Request (PR)

Now it's time to ask the project maintainer to review and merge your code.

1. Go to your fork on GitHub: `https://github.com/your-username/Expense-Tracker`.
2. You should see a banner saying your branch recently pushed. Click **Compare & pull request**.
3. **Verify the branches:**
   - Base repository: `Souma061/Expense-Tracker` | Base: `main`
   - Head repository: `your-username/Expense-Tracker` | Compare: `feature/flutter-ui-setup`
4. **Write a good PR description:**
   - Give it a clear title (e.g., "Implement Flutter Dashboard UI").
   - Describe what you changed and why.
   - If it fixes a specific issue, include "Fixes #123" in the description.
5. Click **Create pull request**.

The maintainer will review your code. They might ask for changes. If they do, simply make the edits locally, `git commit`, and `git push origin your-branch-name`. The PR will update automatically!

---

## 🐞 How to Create an Issue

If you find a bug, need clarification on the API, or want to suggest a new feature, you should create an **Issue**.

1. Go to the original repository: `https://github.com/Souma061/Expense-Tracker`.
2. Click the **Issues** tab near the top.
3. Click the green **New issue** button.
4. **Give it a clear title:** e.g., `BUG: Sync API returns 500 when category is null` or `FEATURE: Add search bar to transactions`.
5. **Provide details:**
   - What did you expect to happen?
   - What actually happened?
   - Steps to reproduce the bug.
   - Any relevant screenshots or error logs.
6. Click **Submit new issue**.

---

## 💡 Quick Cheat Sheet for Daily Work

```bash
# 1. Start your day by updating main
git checkout main
git pull upstream main

# 2. Create a branch
git checkout -b my-new-feature

# 3. Do work, then commit
git add .
git commit -m "Did some work"

# 4. Push to your fork
git push origin my-new-feature

# 5. Go to GitHub and open a Pull Request!
```
