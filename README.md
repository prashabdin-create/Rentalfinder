# Rental Finder — Flask Real-World App

A role-based student rental/property finder built with Flask, SQLite, Leaflet/OpenStreetMap, image uploads, admin moderation, and SMTP email.

## Roles

### Student
- Register/login
- Dashboard with attractive navigation
- Search approved properties
- Enter preferences and choose a location on a map
- Get a transparent match score for each property
- Open property details without seeing owner contact information
- Send a request to the owner
- See request status and details
- Receive an email when the owner accepts/rejects
- See owner contact details only after acceptance

### Owner
- Register/login
- Dashboard
- Add property with multiple photos
- Pick property location on a map or use browser location
- Track property approval/rejection status and admin reason
- See incoming student requests
- Accept/reject requests
- Student receives an email after the decision

### Admin
- Login using credentials from `.env`
- Dashboard statistics
- Manage students, owners and properties
- Review pending properties
- Approve/reject properties with a reason
- Review requests and see full property/owner details
- Rejection reasons are visible to the owner

## Run

1. Create a virtual environment:
   - Windows: `python -m venv .venv`
   - Windows PowerShell: `.venv\Scripts\Activate.ps1`
   - macOS/Linux: `python3 -m venv .venv && source .venv/bin/activate`
2. Install dependencies:
   `pip install -r requirements.txt`
3. Copy `.env.example` to `.env` and configure it.
4. Run:
   `python app.py`
5. Open:
   `http://127.0.0.1:5000`

## Gmail

Use a Gmail App Password for `SMTP_PASSWORD`; do not put your normal Gmail password in the project.

## Notes

- Leaflet uses OpenStreetMap tiles, so an internet connection is needed for the map.
- Uploaded property images are stored under `static/uploads/`.
- SQLite is used by default to keep the project easy to run locally.
- The first app startup creates the database and the admin account from `.env`.
