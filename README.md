# Nyodera Heights Backend API

This repository contains the backend API for the Nyodera Heights property management system.

## Database

The backend now supports PostgreSQL storage via `DATABASE_URL`.

Required environment variables:
- `DATABASE_URL`
- `DATABASE_SSL` (set to `true` if your Postgres provider requires SSL)

If `DATABASE_URL` is not configured, the app will continue to use local JSON files as a fallback.

## Run locally

1. Copy `.env.example` to `.env`
2. Set your database and payment provider environment variables
3. Run `npm install`
4. Start the app with `npm start`
