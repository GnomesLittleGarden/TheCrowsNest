# Crow Nest — one-time setup

The public website can be viewed without an account. The private admin account is only for the person managing Seedspiracy's Crow Nest posts.

## 1. Create the database

1. Go to https://supabase.com/ and create a free project named Crow Nest.
2. Save the database password somewhere private. Do not send it in chat and do not put it in GitHub.
3. When the project has finished provisioning, open SQL Editor.
4. Choose New query.
5. Open supabase-schema.sql in this GitHub repository, copy the whole file, paste it into the SQL Editor and click Run.

That creates the grow journal, field notes, Underground posts, featured videos, access policies and image bucket.

## 2. Create your private admin login

1. In Supabase, open Authentication → Users.
2. Click Add user and create your email/password login.
3. Keep public sign-ups disabled. Visitors do not need accounts.
4. Open SQL Editor → New query and run this, replacing the example email with the exact email used in step 2:

    insert into public.admin_users (user_id)
    select id from auth.users
    where lower(email) = lower('you@example.com')
    on conflict (user_id) do nothing;

This allow-lists only that account to write to Crow Nest. The password stays in Supabase Auth; it is never stored in this repository.

## 3. Connect the website

1. In Supabase, open Project Settings → API (the API keys page).
2. Copy the Project URL.
3. Copy the Publishable key. On older projects it may be labelled anon / public.
4. Do not copy the service_role key or any secret key.
5. Send the Project URL and Publishable/anon key to the person maintaining this repository so they can place them in config.js.

config.js is intentionally blank until those two public connection values are provided. The publishable/anon key is meant to be visible in a browser; the database security policies are what protect drafts and writes.

## 4. Start posting

After the site has redeployed with its connection:

1. Open Crow Nest and click MY BACK POCKET.
2. Sign in with the email/password from step 2.
3. Choose GROWS, FIELD NOTES, UNDERGROUND, or VIDEOS.
4. Add the details. Upload a photo or paste a public image URL where available.
5. Leave Publish this unchecked to save a draft. Check it when you're ready for visitors to see it.
6. Click the relevant SAVE button.

You can return to the same item and use EDIT or DELETE in the admin list. Published changes appear for visitors when saved.

## How the sections work

- Grows: name, plant/cultivar, stage, start date, description and cover photo.
- Field notes: connect a note to a grow; log watering, feeding, light, observations, quantities, light distance/intensity and a photo.
- Underground: longer writing, gear notes, experiments, behind-the-scenes, lessons learned and an optional related YouTube video.
- Videos: add any YouTube video URL to feature it on the front page. The Channel section already links to all SeedSpiracy uploads, Shorts, streams and playlists.

## A couple of important notes

- There are no public member accounts or community posts in this version. Only the owner/admin can publish.
- Do not put private grow information into a public post unless you are comfortable with anyone seeing it.
- Keep an occasional backup of important source text and original photos outside the website.

## Grow Mods / Tinker Bench

The Tinker Bench is the place to kick around possible upgrades for individual grows.

- An admin creates an upgrade idea and links it to a grow.
- Add the category, what you want to change, why it might help, parts/kit needed, rough cost and current status.
- Publish it to put it on the public Tinker Bench.
- Visitors can open an idea and leave a comment without creating an account.
- Visitor comments are private until you approve them in **MY BACK POCKET → DISCUSSION**.
- Use **MOD IDEAS** to edit the upgrade or move it through idea, researching, approved, testing, installed or parked.

If you already ran an earlier version of supabase-schema.sql, run the updated file again. It is written to add the Tinker Bench tables and refresh its policies without deleting existing grow records.
