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

## Deploy

Both directions of sync are automated.

### Laptop → server

1. `git push origin main` from the laptop.
2. [GitHub Actions `CI/CD` workflow](.github/workflows/ci.yml) triggers:
   - `lint` job runs `php -l` on all tracked PHP files.
   - `deploy` job (push to `main` only, gated on lint passing) SSHes to the server and runs `git pull origin main --ff-only`.

### Server → GitHub

1. Cron on the server runs `deploy/server-sync.sh` at minute `:17` each hour.
2. The script regenerates the plugin/theme/WP-core manifest, commits any change, and pushes to GitHub.
3. On the laptop, `git pull` before starting work to pick up server-side updates (plugin auto-updates, manual wp-admin installs, hand-edits).

### Auth wiring

- **Laptop → server:** user SSH key at `~/.ssh/id_ed25519_dreamhost`.
- **Server → GitHub:** deploy key at `~/.ssh/github-kait-us`, registered read-write on this repo.
- **Actions → server:** dedicated CI key — public on server's `authorized_keys`, private stored as `SSH_PRIVATE_KEY` GitHub Actions secret. Companion secrets: `SSH_HOST`, `SSH_USER`, `SSH_KNOWN_HOSTS`.

`wp-config.php` is gitignored and lives only on the server.

## Status

Setup complete (Phases 1–5).
