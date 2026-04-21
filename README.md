# kait.us

WordPress site configuration and custom code for [kait.us](https://kait.us). Hosted on DreamHost.

## Approach

Manifest-only repo — third-party plugins, themes, and WP core are tracked by name and version in `deploy/third-party-*.csv` rather than committed. Keeps the repo small and lets upstream updates happen via WP-CLI on the server.

Custom code lives in:
- `wp-content/themes/gutenify-hustle-child/` — child theme for visual/template overrides
- `wp-content/mu-plugins/` — site-wide PHP hooks and filters
- `wp-content/plugins/kait-*/` — self-contained custom plugins

No local WordPress runtime. The repo is a text-edit + git surface; deploys happen over SSH.

## Layout

- `db-actions.log.md` — append-only record of DB mutations
- `deploy/` — manifest, backup, and deploy scripts

## Status

Phase 1 complete (baseline backup, initial repo, child theme scaffold).
