# Crow Nest — Seedspiracy Grow Journal

A standalone, responsive grow-journal website for Seedspiracy.

## Included in this first build
- Public grow cards with stage progress and days since start.
- Field notes filtered by watering, feeding, lighting and observations.
- Admin console for creating, editing and deleting grow records.
- Field-entry logging for amounts, light distance, intensity and photo URLs.
- YouTube video embeds.
- JSON export/import backups.
- Responsive dark botanical / underground visual identity.

## Preview-mode limitations
This first version stores records in the current browser's localStorage. It is not a shared database: edits do not sync to other devices or visitors. The admin console is not yet protected by server-side authentication. Treat this as a functional prototype, not a production content-management system.

## Production milestones
1. Connect a dedicated Supabase project for shared data and image storage.
2. Add authenticated admin access and reviewed Row Level Security policies.
3. Connect a separate hosting project and custom domain/subdomain.
4. Replace sample content with approved Seedspiracy field records.

Do not place Supabase service-role keys or other secrets in this repository.

## Local preview
Open index.html in a modern browser. No build step is required.
