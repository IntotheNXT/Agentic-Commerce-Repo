# How to Sell to an Agent — Repository Operating Manual

A living research repository on **agentic commerce**, built to feed a November 2026 keynote and white paper, and to remain a public reference at **howtoselltoanagent.com**.

## The core question
Byron Sharp's laws — **physical availability** (easy to find/buy) and **mental availability** (salient, distinctive, top-of-mind) — assume a *human* makes the purchase. When an *agent* decides, what survives? This repo collects evidence on whether mental availability collapses into **structured-data availability, feed quality and machine-readable trust**.

## Folder map
```
agentic-commerce-repo/
├── sources/
│   └── sources.json          ← SINGLE SOURCE OF TRUTH (all sources, one JSON array)
├── generation/templates/     ← white-paper + keynote templates
├── output/                   ← the public site (self-contained HTML)
│   ├── index.html            ← source library w/ theme + type filters (data embedded)
│   ├── white-paper.html      ← white paper
│   └── keynote.html          ← keynote deck outline
├── scripts/build.ps1         ← embeds sources.json into the site
└── workflow/
    ├── README.md             ← this file
    ├── changelog.md          ← log of every cycle + approvals
    └── approval-queue.json   ← items awaiting your sign-off this cycle
```

## Source schema (each entry in sources.json)
`id, title, url, source_type, themes[], date_published, date_collected, publisher, summary, key_quote, relevance_to_sharp, status`

- **themes** (primary filter): `consumer-behavior · brand-strategy · retailer-impact · regulatory · tech-capability`
- **source_type** (secondary filter): `news · research-report · company-announcement · analysis · academic`
- **status**: `collected` (new, unreviewed) → `approved` (you signed off) → `published` → `archived`

## The biweekly cycle
1. **Collect** — automated search runs across the five themes; new sources appended to `sources.json` with `status:"collected"` and added to `approval-queue.json`. Deduplicated by URL.
2. **Review (you)** — every two weeks you open `approval-queue.json` (or the "new" badges on the site) and approve / reject each new source. A "major change" to the white paper or keynote (new theme, ≥3 new sources in a theme, or a consensus shift) is flagged for explicit sign-off.
3. **Regenerate** — approved sources flip to `status:"approved"`; white paper + keynote are regenerated; `build.ps1` re-embeds the data into the site.
4. **Publish** — site updates; `changelog.md` records what changed, what you approved, and when.

## To rebuild the site manually
```powershell
pwsh "scripts/build.ps1"
# then open output/index.html
```

## Hosting (to point howtoselltoanagent.com at it)
The `output/` folder is fully static and self-contained (data embedded in the HTML — works by double-clicking locally *and* when hosted). Deploy `output/` to Netlify, Vercel, GitHub Pages, or any static host, then point the domain's DNS at it. No server or build pipeline required on the host.

## Notes
- **Web access:** source collection must run in an environment with WebSearch/WebFetch (the main session has it; isolated subagents in this setup did not). The scheduled job must run somewhere with web access.
- **Mollie** was requested as a watch-source; as of Cycle 0 (19 Jun 2026) nothing verifiable was found. As of Cycle 1 (19 Jun 2026, later collection run) Mollie now has genuinely relevant, verifiable coverage (ACP compatibility for European merchants) — see `tc-c1-04` in `sources.json`.
