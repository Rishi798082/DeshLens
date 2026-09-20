# Development Guide

## Python environment

Create a Python 3.14 virtual environment from the project root when one is needed:

```powershell
py -3.14 -m venv .venv
```

Activate it in PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

Deactivate it with `deactivate` when finished. No backend dependencies are installed or configured yet.

## Frontend

From `frontend/`, start the existing Next.js application:

```powershell
npm run dev
```

Visit the local URL printed by Next.js (normally `http://localhost:3000`).

## Backend (later)

The backend will be a FastAPI application under `backend/`. Once it exists and its dependencies are defined, activate `.venv` and run the documented FastAPI development command from the project root. Do not add backend packages or endpoints as part of this initialization.

## Git workflow

Initialize Git when the project is ready for version control:

```powershell
git init
git add .
git commit -m "Initialize DeshLens project structure"
```

Use focused branches, make small purposeful commits, review `git status` before committing, and avoid committing generated files, virtual environments, local data, or secrets.
