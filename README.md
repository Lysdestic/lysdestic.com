# lysdestic.com

A personal landing page built with [Astro](https://astro.build). Hosted on shared cPanel hosting behind Cloudflare.

![Homepage screenshot](docs/homepage.png)

---

## Stack

-   **[Astro](https://astro.build) v6** — static site generator, outputs flat HTML/CSS/JS
-   **[astro-icon](https://github.com/natemoo-re/astro-icon)** with `@iconify-json/ion`, `@iconify-json/mdi`, `@iconify-json/simple-icons` — icon sets
-   **[@fontsource/albert-sans](https://fontsource.org/fonts/albert-sans)** and **[@fontsource/rokkitt](https://fontsource.org/fonts/rokkitt)** — self-hosted fonts
-   **Prettier** — code formatting
-   **TypeScript** (strict) — via `astro/tsconfigs/strictest`
-   **[@astrojs/check](https://docs.astro.build/en/guides/typescript/#type-checking)** — typed diagnostics for `.astro` files and scripts
-   Deployed to **cPanel shared hosting** (The Hosting Folks), proxied through **Cloudflare**

---

## Project structure

```
src/
  assets/           # Static assets (avatar, gifs)
  components/
    astro/          # Astro components (Header, Footer, LinkNewTab, Email, VideoPlayer, Navigation)
  data/             # Typed data files
    contactLinks.ts # Footer social/contact links
    mediaLinks.ts   # Band links on the Media page
    quotes.ts       # Reading quotes shown randomly on About page
    site.ts         # Site config (host, CDN)
  layouts/
    Layout.astro    # Base layout wrapping all pages
  pages/            # One file per route
    index.astro     # Homepage (/)
    media.astro     # /media
    about.astro     # /about
    contact.astro   # /contact
    nerds.astro     # /nerds (hidden, not in nav)
    404.astro       # 404 page
  styles/
    global.css      # All global styles, animations, dark mode
```

---

## Pages

| Page            | Route      | Notes                                                     |
| --------------- | ---------- | --------------------------------------------------------- |
| Home            | `/`        | "Howdy" heading, gradient hero with intro text            |
| Media           | `/media`   | "Music" heading + band links + VideoPlayer thumbnail cycling |
| About           | `/about`   | "Interests" heading, icon grid, random reading quote      |
| Contact         | `/contact` | Custom heading + LinkedIn/GitHub/email links              |
| Stats for Nerds | `/nerds`   | Hidden page — client/display/build stats, troubleshooting |
| 404             | `/404`     | Homer backing into bushes gif                             |

All pages use `Layout.astro`. Most pages use `includeHeading` with `subtitle` (subtitle becomes the `<h1>` and tab title), while pages can also render a custom `<h1>` directly when needed.

---

## Styling

Everything lives in `src/styles/global.css`, organized into sections:

-   **Custom properties** — `--dark`, `--light`, `--mid`, light/dark gradient backgrounds
-   **Animations** — `gradient` (text), `link-underline` (anchor underlines), `lcars-stripe` (LCARS bar), `fade-in` (h1 page load), `slide-in-right` (content block page load)
-   **Base/reset** — box-sizing, font smoothing, body constraints
-   **Typography** — heading sizes, font families
-   **Links** — animated gradient underline using `background-image` trick; suppressed on `.contacts-container a` (footer icons)
-   **Components** — `.gradient-container` (animated gradient text + LCARS left stripe), `.heading-name`, `.role`
-   **Responsive** — breakpoint at `600px`
-   **Dark mode** — `prefers-color-scheme: dark`

### LCARS accent

`.gradient-container` gets a 4px animated left border stripe via `::before`, cycling through the same purple/blue palette as the text gradient. Used on all content pages.

### Page animations

On every page load, the `<h1>` fades in over 2s and the `.gradient-container` content block slides in subtly from the right over 1.5s.

### Stardate / siterev

The footer displays a build-time stardate using the TNG formula anchored to the TNG premiere date (July 15, 1987):

```
(((now - epoch) / 1000 / 3155.76) + 410000) / 10
```

Reference: [trekguide.com/Stardates.htm](https://trekguide.com/Stardates.htm)

The stardate is calculated once in `deploy.sh` at deploy time and passed to the Astro build as `PUBLIC_STARDATE`. `package.json` version is also set to the stardate on each deploy — an unorthodox but intentional versioning scheme that makes the version human-readable and traceable to a specific deploy moment.

In local dev (`npm run dev`), `PUBLIC_STARDATE` is not set and the footer displays `siterev dev` as a fallback.

---

## Data files

| File              | Purpose                                                                           |
| ----------------- | --------------------------------------------------------------------------------- |
| `contactLinks.ts` | Social/contact links used in footer and contact page                              |
| `mediaLinks.ts`   | Band links and metadata for the media page                                        |
| `quotes.ts`       | Reading quotes — one is picked client-side on page load and shown on the About page |
| `site.ts`         | Site-level config: host provider name, CDN name                                   |

To add a quote, append an entry to `quotes.ts` with `text`, `source`, and `author` fields.

---

## Making changes

### Adding a social/contact link

1. Add an entry to `src/data/contactLinks.ts`
2. Destructure it in `Footer.astro`
3. Add a `<LinkNewTab>` + `<Icon>` block inside `.contacts-container`

### Adding a media link

1. Add an entry to `src/data/mediaLinks.ts`
2. Destructure it in `src/pages/media.astro`
3. Add a `<LinkNewTab>` block in the article

### Adding a video to the media player

Add an entry to the `videos` array in `src/pages/media.astro`:

```
{ id: 'YOUTUBE_VIDEO_ID', title: 'Band - Song Title' }
```

### Adding a page

1. Create `src/pages/yourpage.astro`
2. Use `<Layout includeHeading subtitle="Page Title">`
3. Wrap content in `<article class="gradient-container">` for the LCARS stripe
4. Add a nav link in `src/components/astro/Navigation.astro`

---

## Local dev

```bash
npm install
npm run dev       # http://localhost:4321
npm run check     # astro/type diagnostics
npm run build     # builds to dist/
npm run preview   # preview the build locally
npm run format    # run prettier across all files
```

---

## Deploying to cPanel

This site builds to static files via Astro and is manually deployed to cPanel shared hosting.

### Steps

1. Make sure all changes are committed and pushed to `main`.
2. Run the deploy script:

```bash
./deploy.sh
```

3. It will calculate the current stardate, write it to `package.json` as the version, build the site, and create a timestamped `.zip` in `deploy_upload/` (gitignored), named after the most recent commit message.
4. Log into cPanel → **File Manager** → navigate to `public_html/`.
5. Click **Upload**, select the `.zip`, then once uploaded, right-click it → **Extract** → extract into `public_html/`.
6. Delete the `.zip` from the server after extracting.
7. In cPanel, purge the host's cache.
8. In Cloudflare, purge cache if still stale (Caching → Purge Everything, or via API).
9. Commit the `package.json` version bump:

```bash
git add package.json
git commit -m "siterev $(node -p "require('./package.json').version")"
git push
```

### Notes

-   `deploy_upload/` is gitignored — zips never get committed.
-   `dist/` is also gitignored — the build output is never committed.
-   Astro config uses `output: 'static'` (default) — no server process required on the host.
-   The host (The Hosting Folks) runs its own cache layer. **Always purge there first** after deploying, before touching Cloudflare.
-   Cloudflare sits in front — if the host cache is clear but site still looks stale, purge Cloudflare too.

---

## robots.txt

A `robots.txt` is maintained in `public_html/` on the server (not committed to the repo since it lives outside the build output). It disallows crawling of `/nerds/` to keep the hidden stats page out of search indexes:

```
User-agent: *
Disallow: /nerds/
```

---

## Dependencies of note

| Package                      | Why                                                                         |
| ---------------------------- | --------------------------------------------------------------------------- |
| `astro-icon`                 | Icon component wrapper for Iconify icon sets                                |
| `@iconify-json/ion`          | Ion icon set — GitHub, LinkedIn, mail, Facebook, music note icons in footer |
| `@iconify-json/mdi`          | MDI icon set — interest icons on About page                                 |
| `@iconify-json/simple-icons` | Simple Icons set — openSUSE, Star Trek icons on About page                  |
| `@fontsource/albert-sans`    | Body/UI font, self-hosted                                                   |
| `@fontsource/rokkitt`        | Heading font, self-hosted                                                   |
| `@astrojs/check`             | Astro + TypeScript diagnostics (`npm run check`)                            |
| `typescript`                 | Type checker used by Astro and `@astrojs/check`                             |
| `prettier`                   | Code formatting — run with `npm run format`                                 |
| `prettier-plugin-astro`      | Enables Prettier to format `.astro` files                                   |
