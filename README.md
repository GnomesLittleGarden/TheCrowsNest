# Crow Nest — the Seedspiracy field journal

Crow Nest is a separate public grow journal for Seedspiracy. It has a relaxed, earthy, slightly psychedelic/grunge visual identity and is designed to feel like an actual field notebook rather than a corporate dashboard.

## Public site
- Current grow cards and progress.
- Published field notes with filters for watering, feeding, lighting and observations.
- Longer Underground posts for gear notes, experiments, behind-the-scenes and lessons learned.
- Featured YouTube videos embedded on the site.
- The Tinker Bench for grow upgrade ideas, status tracking and moderated discussion.
- Direct links to the complete SeedSpiracy YouTube library: videos, Shorts, livestreams and playlists.
- Visitors do not need accounts.

## Private publishing
The “MY BACK POCKET” button opens the private admin sign-in. Once authenticated and allow-listed as an admin, the owner can create, edit and delete:
- Grows and grow stages.
- Field notes, measurements and photos.
- Underground articles and long-form notes.
- Featured YouTube videos.

Items are saved as drafts until “Publish this” is checked. Publishing updates the public website through Supabase. Images upload to the crow-nest-media storage bucket.

## Important: finish the one-time cloud connection
The front end and database policies are prepared, but **shared posting is not live until Supabase is connected**. The browser-only/localStorage demo has been removed to avoid pretending an edit is visible to everyone when it is not.

Follow SETUP.md. The updated SQL also includes the Tinker Bench and moderated visitor discussion. You will need a Supabase project, then the project URL and public publishable/anon key. The key is designed to be used in a browser; never use a service_role or secret key in config.js.

## Files
- index.html — public site and admin interface.
- config.js — Supabase public connection settings (blank until configured).
- supabase-schema.sql — tables, security policies, admin allow-list and public image bucket.
- SETUP.md — exact one-time setup instructions.

## Hosting
GitHub Pages deploys the static site from the main branch using .github/workflows/pages.yml.
