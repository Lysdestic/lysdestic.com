A simple landing page inspired by a friend's design using Astro.

## Deploying to cPanel

This site builds to static files via Astro and is manually deployed to cPanel shared hosting.

### Steps

1. Make sure all changes are committed and pushed to `main`.
2. Run the deploy script:
```bash
   ./deploy.sh
```
3. It will build the site and create a timestamped `.zip` in `deploy_upload/` (gitignored).
4. Log into cPanel → **File Manager** → navigate to `public_html/`.
5. Click **Upload**, select the `.zip`, then once uploaded, right-click it → **Extract** → extract into `public_html/`.
6. Delete the `.zip` from the server after extracting.

### Notes
- The `deploy_upload/` directory is gitignored — zips never get committed.
- Astro config should have `output: 'static'` (or omit `output` entirely).
- No server process required on the host — it's all flat files.