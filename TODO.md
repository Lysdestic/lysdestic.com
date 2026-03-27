# TODO

## High Priority

-   [ ] **Merge `newblogv6` into `main`** — blog is feature-complete and tested, ready to ship
-   [ ] **Create `robots.txt` on server** — manually create in `public_html/` on cPanel (not committed, lives outside build output). Template in README. Include `/nerds/` disallow and AI crawler blocks.
-   [ ] **Automate deploy** — investigate SFTP (check cPanel SSH Access) and LiteSpeed Cache purge API (check cPanel for Cache Manager section). Goal: `deploy.sh` handles upload + cache purge with no manual steps.
-   [x] **Fix siterev mismatch (`sitrev` vs `siterev`)** — footer text and `/nerds` parser disagree, causing fallback to `dev`
-   [ ] **Add CI quality gate** — run build + format check on push/PR to catch regressions before deploy

## Medium Priority

-   [x] **Delete `src/data/icons.ts`** — dead file, nothing imports it, references a `uil` icon set that isn't installed
-   [x] **Delete `src/components/astro/Project.astro`** — dead component, never used after projects page was removed
-   [ ] **Sitemap submission** — sitemap now generates at `/sitemap-index.xml`, submit to Google Search Console and Bing Webmaster Tools
-   [x] **Hamburger: close on nav link click** — drawer stays open after navigating, should auto-close
-   [x] **Hamburger: close on Escape key** — keyboard accessibility
-   [x] **Hamburger: only close on Escape when drawer is open** — avoid stealing focus when nav is already closed
-   [x] **VideoPlayer empty-state guard** — prevent `videos[0]` crash if list is empty
-   [ ] **External links hardening** — use `rel="noopener noreferrer"` anywhere `target="_blank"` is used
-   [ ] **Install `@astrojs/check` and add `npm run check`** — enable typed Astro checks in regular workflow

## Low Priority / Nice to Have

-   [x] **CSS consolidation** — scoped `<style>` blocks scattered across `.astro` files. Astro's design encourages this pattern so it's not wrong, but shared patterns like `.quote-source`, `.salute`, `.tag`, `.interests` could move to `global.css`. Leave component-specific layout CSS in their files. Not urgent.
-   [ ] **`about.astro` interest grid** — table layout works but CSS grid would be cleaner markup and better responsive behaviour
-   [ ] **Blog: write real first post** — delete `hello-world.md` and `second-post.md` test posts before going live
-   [ ] **Blog: tags on index page** — tags show on post pages but not on the blog index listing
-   [ ] **README** — update once blog merges to main (add blog section, update project structure and pages table)
-   [ ] **README wording fix (quotes behavior)** — docs say quote is chosen at build time, but it is currently randomized client-side
-   [ ] **Run Prettier cleanup pass** — `prettier --check` currently flags `package.json`, `Header.astro`, `LinkNewTab.astro`, and `404.astro`
-   [ ] **Add more quotes to `quotes.ts`** — current pool is 11, more variety = better per-visit randomness

## Deferred

-   [ ] **Media page bio copy** — punchy rewrite deferred, current wording still the old placeholder
