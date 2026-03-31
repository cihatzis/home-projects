# Projecten - Setup Guide

A mobile-first project/task manager PWA with real-time sync between users.

## What you need

- A **personal GitHub account** (free) — [github.com](https://github.com)
- A **Supabase account** (free) — [supabase.com](https://supabase.com) (sign up with that GitHub account)

## Step 1: Create Supabase project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click **New Project**
3. Name it `projecten` (or anything), pick a password, choose the closest region (eu-west)
4. Wait for the project to be created (~1 min)

## Step 2: Create tables & seed data

1. In your Supabase dashboard, go to **SQL Editor** (left sidebar)
2. Click **New query**
3. Copy-paste the entire contents of `supabase-setup.sql` into the editor
4. Click **Run** (or Ctrl+Enter)
5. You should see "Success. No rows returned" — this is correct

## Step 3: Enable Realtime

1. Go to **Database** → **Replication** in the left sidebar
2. Under "Supabase Realtime", toggle ON the source `supabase_realtime`
3. Verify that `projecten`, `onderdelen`, and `taken` tables are listed

> If the tables don't show up in Replication, the `ALTER PUBLICATION` statements from the SQL already handled it.

## Step 4: Get your API keys

1. Go to **Settings** → **API** in the left sidebar
2. Copy the **Project URL** (looks like `https://xxxxx.supabase.co`)
3. Copy the **anon public** key (starts with `eyJhbGciOi...`)

You'll enter these in the app on first launch.

## Step 5: Deploy to GitHub Pages

1. Create a **new repository** on GitHub (e.g. `projecten`)
2. Make it **private** if you want
3. Push the files:

```bash
cd project-manager
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/projecten.git
git push -u origin main
```

4. Go to your repo on GitHub → **Settings** → **Pages**
5. Under "Source", select **Deploy from a branch**
6. Branch: `main`, folder: `/ (root)`, click **Save**
7. Wait ~1 min, your app will be at: `https://YOUR_USERNAME.github.io/projecten/`

## Step 6: Install on your phone

1. Open the URL on your phone's browser (Chrome on Android, Safari on iPhone)
2. **Android**: tap the 3-dot menu → "Add to Home screen" or "Install app"
3. **iPhone**: tap the Share button → "Add to Home Screen"
4. On first launch, enter your Supabase URL and anon key
5. Done! Both users install the same way on their phones

## Features

- **Drill-down navigation**: Projects → Onderdelen → Taken
- **Drag to reorder**: grab the ⠿ handle and drag to change priority/order
- **Real-time sync**: changes by one user appear instantly for the other
- **Quick toggle**: tap checkboxes to mark items as gereed
- **Add/Edit/Delete**: full CRUD on all three levels
- **PWA**: installable on home screen, works like a native app

## Dropdown values

| Field | Values |
|-------|--------|
| Status | Niet gestart, Onderhanden, Gereed |
| Planning | 2026-Q1 through 2027-Q4 |
| Door | CH, SK, Extern |

These can be changed in `index.html` if needed.
