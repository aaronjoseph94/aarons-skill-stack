# Aaron's Skill Stack

> My every-machine starter kit for coding agents — Cursor, Claude Code, Codex, Copilot, Windsurf, and friends.
> Clone it, run the installer, and every new agent inherits the same workflow, discipline, taste, and verification layer.

Star counts are approximate as of Oct 2026 and move fast on trending repos — treat them as order-of-magnitude.

---

## Contents

- [Quick reference](#quick-reference)
- [Architecture — where each skill sits](#architecture--where-each-skill-sits)
- [The 10 skills](#the-10-skills)
  - [1. Superpowers — the workflow backbone](#1-superpowers--the-workflow-backbone)
  - [2. Matt Pocock's Skills — engineering judgment](#2-matt-pococks-skills--engineering-judgment)
  - [3. Addy Osmani's Agent Skills — the gated lifecycle](#3-addy-osmanis-agent-skills--the-gated-lifecycle)
  - [4. Caveman — the token saver](#4-caveman--the-token-saver)
  - [5. Ponytail — the minimalist](#5-ponytail--the-minimalist)
  - [6. Agent-Reach — the agent's eyes](#6-agent-reach--the-agents-eyes)
  - [7. Understand-Anything — the codebase map](#7-understand-anything--the-codebase-map)
  - [8. UI/UX Pro Max — the taste layer](#8-uiux-pro-max--the-taste-layer)
  - [9. EvilCharts — dashboard charts that don't look cheap](#9-evilcharts--dashboard-charts-that-dont-look-cheap)
  - [10. TesterArmy E2E — proof it works](#10-testerarmy-e2e--proof-it-works)
- [Also worth knowing](#also-worth-knowing)
- [Install everything at once](#install-everything-at-once)
- [Push this to GitHub](#push-this-to-github)

---

## Quick reference

| # | Skill | What it gives you | Layer |
|---|-------|-------------------|-------|
| 1 | [Superpowers](https://github.com/obra/superpowers) | brainstorm → plan → execute, TDD, debugging, code review | Workflow |
| 2 | [Matt Pocock's Skills](https://github.com/mattpocock/skills) | Grill ideas, specs, tickets, TDD from a real engineer's setup | Discipline |
| 3 | [Addy Osmani's Agent Skills](https://github.com/addyosmani/agent-skills) | spec → plan → build → test → review → ship with verification gates | Discipline |
| 4 | [Caveman](https://github.com/JuliusBrussee/caveman) | ~65–75% fewer output tokens, zero accuracy loss | Behavior |
| 5 | [Ponytail](https://github.com/DietrichGebert/ponytail) | Simplest correct implementation, ~54% less code | Behavior |
| 6 | [Agent-Reach](https://github.com/Panniantong/Agent-Reach) | Internet access: X, Reddit, YouTube, GitHub — no paid APIs | Knowledge |
| 7 | [Understand-Anything](https://github.com/Egonex-AI/Understand-Anything) | Interactive knowledge graph of your codebase | Knowledge |
| 8 | [UI/UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | 79 UI styles, 192 palettes, design-system generator | Design |
| 9 | [EvilCharts](https://github.com/legions-developer/evilcharts) | Beautiful animated chart components for dashboards | Design |
| 10 | [TesterArmy E2E](https://github.com/tester-army/e2e) | AI-driven E2E tests; record once, replay with zero tokens | Verify |

---

## Architecture — where each skill sits

```mermaid
flowchart TB
    subgraph L1["LAYER 1 · WORKFLOW BACKBONE — install first"]
        SP["obra/superpowers<br/>brainstorm → plan → execute<br/>TDD · debugging · code review"]
    end
    subgraph L2["LAYER 2 · KNOWLEDGE — what the agent knows"]
        UA["Egonex-AI/Understand-Anything<br/>knowledge graph of YOUR codebase"]
        AR["Panniantong/Agent-Reach<br/>the internet: X · Reddit · YouTube · GitHub"]
    end
    subgraph L3["LAYER 3 · ENGINEERING DISCIPLINE"]
        MP["mattpocock/skills<br/>grill → spec → tickets → TDD"]
        AO["addyosmani/agent-skills<br/>spec → plan → build → test → review → ship<br/>verification gates"]
    end
    subgraph L4["LAYER 4 · BEHAVIOR MODIFIERS — how the agent acts"]
        CV["JuliusBrussee/caveman<br/>-65–75% output tokens"]
        PT["DietrichGebert/ponytail<br/>simplest correct implementation"]
    end
    subgraph L5["LAYER 5 · BUILD — design & components"]
        UX["nextlevelbuilder/ui-ux-pro-max-skill<br/>design systems · styles · palettes · fonts"]
        EC["legions-developer/evilcharts<br/>dashboard chart components"]
    end
    subgraph L6["LAYER 6 · VERIFY — prove it works"]
        E2E["tester-army/e2e<br/>AI E2E tests · record & replay<br/>zero-token reruns"]
    end

    SP --> UA
    SP --> AR
    UA --> MP
    MP --> CV
    AO -. discipline on top of .-> SP
    CV --> UX
    PT --> UX
    UX --> EC
    UX --> E2E
```

**How to read it:** the agent *plans* with Layer 1, *understands* your code and the web with Layer 2, follows *engineering discipline* in Layer 3, writes *terse, minimal code* via Layer 4, builds *designed* UIs in Layer 5, and *proves it works* in Layer 6. Install in layer order — each layer assumes the one above it.

---

## The 10 skills

### 1. Superpowers — the workflow backbone

🔗 **https://github.com/obra/superpowers** · ~large community · MIT

**What it is.** A core library of 20+ skills plus `/brainstorm`, `/write-plan`, and `/execute-plan` commands. It forces the agent to follow a process before responding: brainstorm before coding, write a plan before executing, do test-driven development (red → green → refactor), debug systematically (4-phase root-cause analysis), get a code review, and verify a fix actually works before claiming it's done.

**How it helps.** Without it, every agent improvises its own process and you get a different quality of work every session. With it, every agent follows the same battle-tested workflow. It's the single highest-leverage install on this list.

**Where it's useful.** Any non-trivial task — features, refactors, bug fixes, anything spanning more than a couple of files.

**Install** (Claude Code):
```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```
Other agents: `npx skills@latest add obra/superpowers -g`

**Example.**
> You: "Add user authentication to the API."
> Agent (with Superpowers): doesn't write code yet. Runs `/brainstorm`, asks how users sign in, what the session strategy is, which routes need protection — *then* writes a plan, *then* executes it, and verifies the login flow works before saying "done."

---

### 2. Matt Pocock's Skills — engineering judgment

🔗 **https://github.com/mattpocock/skills** · ~242k stars · MIT

**What it is.** "Skills for Real Engineers. Straight from my .agents directory." The actual everyday workflow of Matt Pocock (Total TypeScript / AI Hero): `grill-with-docs` (interrogate the idea before building), `to-prd` / `to-spec` / `to-tickets` (idea → spec → sliced tickets), `tdd`, `diagnosing-bugs`, `code-review`, plus shared context conventions (`CONTEXT.md`, ADRs).

**How it helps.** It makes the agent do the engineering *thinking*, not just the typing. Decisions get made up front and the agent is held to them during the build — no more "the agent built the wrong thing really fast."

**Where it's useful.** Starting features, shaping vague ideas into buildable plans, and anywhere you want the agent to challenge your requirements before coding.

**Install:** `npx skills@latest add mattpocock/skills -g`

**Example.**
> You: "Build me an authenticated API endpoint."
> Agent (with `grill-with-docs`): asks ~35 questions first — Bearer token vs JSON body? Rate limit at exactly 1,000 requests/day or soft? What does the error response look like? — the decisions *you* hadn't consciously made until the machine forced you to. Then it builds exactly what you agreed on.

> ⚠️ Overlap: this collection is also vendored inside [alirezarezvani/claude-skills](#also-worth-knowing). Install one, not both.

---

### 3. Addy Osmani's Agent Skills — the gated lifecycle

🔗 **https://github.com/addyosmani/agent-skills** · ~60–90k stars · MIT

**What it is.** ~20 structured skills with 7 slash commands mapping the full dev lifecycle — `/spec`, `/plan`, `/build`, `/test`, `/review`, `/code-simplify`, `/ship` — plus specialist personas (code reviewer, test engineer, security auditor). Two signature ideas: **anti-rationalization tables** (each skill lists the excuses agents use to skip steps, with documented rebuttals) and **verification gates** (the agent must show evidence — e.g. passing tests — before a phase counts as done).

**How it helps.** Agents love to skip steps and declare victory. This skill is engineered specifically to stop that. If Superpowers is the process and Pocock is the judgment, Osmani is the quality gate at every phase.

**Where it's useful.** Production code, team repos, anything where "it works on my machine" isn't good enough.

**Install:** `npx skills@latest add addyosmani/agent-skills -g`

**Example.**
> Agent finishes `/build` and wants to move on. The verification gate stops it: "Show me the passing tests." No green tests, no `/ship`. The agent runs the suite, fixes the two failures it was hoping you'd miss, and *then* ships.

---

### 4. Caveman — the token saver

🔗 **https://github.com/JuliusBrussee/caveman** · ~100k stars · Apache-2.0

**What it is.** *"Why use many token when few token do trick."* A skill that makes the agent drop filler, articles, and hedging while keeping every technical detail exact. Six intensity levels (`lite` → `full` → `ultra` → `wenyan`), plus `/caveman-commit`, `/caveman-review`, `/caveman-stats` (tracks your USD savings), and a local proxy that compresses inputs too.

**How it helps.** You pay per token and read every word the agent writes. ~65–75% output-token savings with no accuracy loss — the author's study even found brevity *improved* accuracy. Pure cost and signal-to-noise win.

**Where it's useful.** Everywhere, always. Especially long sessions where context window is precious.

**Install:** `npx skills@latest add JuliusBrussee/caveman -g`

**Example.**
> Before: "I've successfully implemented the requested feature. The changes I made include modifying three files. First, I updated the configuration file to add the new setting…"
> After (caveman): "Done. 3 files changed: `config.ts` (+12), `auth.ts` (+48), `auth.test.ts` (+31). All 14 tests pass."

---

### 5. Ponytail — the minimalist

🔗 **https://github.com/DietrichGebert/ponytail** · ~150k stars · MIT

**What it is.** The "laziest senior dev" skill. A seven-rung ladder the agent checks before writing code, steering it toward the simplest correct implementation. Tagline: *"He says nothing. He writes one line. It works."* Author-benchmarked: ~54% fewer lines of code, ~22% fewer tokens, ~27% faster across real feature tasks.

**How it helps.** Agents default to over-engineering — new dependencies, abstractions, design patterns nobody asked for. Ponytail is the counterweight. Combined with Caveman, your agent writes less *and* says less.

**Where it's useful.** Feature work, prototypes, and any codebase where you value simplicity over cleverness.

**Install:** `npx skills@latest add DietrichGebert/ponytail -g`

**Example.**
> You: "I need a date picker on the signup form."
> Agent without Ponytail: installs a date-picker library, adds 40KB to the bundle, wires up a theme adapter.
> Agent with Ponytail: ships `<input type="date">`. One line. Works on every browser. Done.

---

### 6. Agent-Reach — the agent's eyes

🔗 **https://github.com/Panniantong/Agent-Reach** · ~92k stars · MIT

**What it is.** A CLI capability layer giving any agent read/search access to the internet — X/Twitter, Reddit, YouTube, GitHub, Bilibili, XiaoHongShu, Facebook, Instagram, LinkedIn, RSS — with **zero paid APIs**. Each platform has ordered preferred + fallback backends, and `agent-reach doctor` diagnoses which route is currently live.

**How it helps.** Coding agents are blind to the living web: docs, threads, issues, video tutorials. This is their eyes. The multi-backend routing means when one scraper gets blocked, it fails over automatically with no action from you.

**Where it's useful.** Research tasks ("what's the current best auth library?"), debugging obscure errors, checking real-world opinions before choosing a dependency.

**Install:** `agent-reach install` (point the agent at the repo's `docs/install.md`; it handles the rest). Safety flags: `--dry-run`, `--system`.

**Example.**
> You: "Which React table library should I use in 2026?"
> Agent (with Agent-Reach): searches Reddit threads, GitHub issues, and recent X posts — not just its training data — and comes back with "TanStack Table, and here's what people complain about with the alternatives," citing actual discussions.

---

### 7. Understand-Anything — the codebase map

🔗 **https://github.com/Egonex-AI/Understand-Anything** · ~85k stars · MIT

**What it is.** Analyzes your project with a multi-agent pipeline and builds an **interactive knowledge graph** — every file, function, class, and dependency as explorable nodes. Ships a web dashboard, guided architectural tours, semantic search, diff impact analysis, and onboarding-guide generation. Philosophy: "Graphs that teach > graphs that impress."

**How it helps.** Every new repo (or new agent session on an old repo) starts with the agent guessing where things live. This replaces guessing with a map — the agent asks the graph instead of grepping blindly.

**Where it's useful.** Onboarding onto unfamiliar codebases, large refactors ("what breaks if I change this?"), and handing context to teammates via the shareable dashboard.

**Install** (Claude Code):
```
/plugin marketplace add Egonex-AI/Understand-Anything
/plugin install understand-anything
```
Other agents: one-line `curl …/install.sh | bash -s <platform>` (see repo README). Note: the first `/understand` run on a large codebase is token-heavy; later runs are incremental.

**Example.**
> You (new repo, first session): `/understand`
> You: "Which parts handle auth?"
> Agent: opens the knowledge graph, traces `login()` → `session.ts` → the middleware chain, and shows you the full call path — instead of reading 200 files to answer.

---

### 8. UI/UX Pro Max — the taste layer

🔗 **https://github.com/nextlevelbuilder/ui-ux-pro-max-skill** · ~133k stars · MIT

**What it is.** Design intelligence for coding agents: **79 searchable UI styles, 192 industry-specific reasoning rules, 192 color palettes, 74 font pairings, 119 UX guidelines.** The v2 flagship is a Design System Generator that reasons over your product brief and emits a complete design system (pattern + style + colors + typography + effects + anti-patterns + pre-delivery checklist), persistable to `design-system/<project>/MASTER.md` for cross-session consistency.

**How it helps.** Agents write functional-but-ugly UIs by default. This is the taste layer — it makes agent-built interfaces look *designed* instead of *generated*. The most-starred repo on this list.

**Where it's useful.** Any UI the agent builds: landing pages, dashboards, marketing sites, app screens.

**Install:** `npm install -g ui-ux-pro-max-cli && uipro init --ai <your-agent>` (or `--ai all` for every agent). Requires Node.js + Python 3.

**Example.**
> You: "Build a landing page for a fitness app."
> Agent (with UI/UX Pro Max): generates a full design system first — style direction, palette, font pairing, spacing rules — saves it to `design-system/fitness-app/MASTER.md`, then builds every section against it. Next session, the agent reuses the same system. Consistent, not random.

---

### 9. EvilCharts — dashboard charts that don't look cheap

🔗 **https://github.com/legions-developer/evilcharts** · ~3k stars · MIT

**What it is.** An open-source chart component library built on shadcn + Recharts — handcrafted, animated bar/line/area/pie/radar components for React/Next.js dashboards. Ships `.claude/skills/` and `.agents/skills/` directories so agents can use it correctly out of the box.

**How it helps.** Dashboards are where agent-built UIs look cheapest, and charts are the hard part. Instead of hand-rolled SVGs, the agent pulls from a curated component source.

**Where it's useful.** Admin panels, analytics pages, any dashboard with data visualization.

**Install:** `npx skills@latest add legions-developer/evilcharts -g` for the agent skill; components install shadcn-style when building (see [evilcharts.com](https://evilcharts.com)).

**Example.**
> You: "Add a revenue chart to the admin dashboard."
> Agent (with EvilCharts): pulls an animated area chart component with gradient fill, tooltip, and responsive container — instead of spending 200 lines hand-rolling one that looks like a spreadsheet.

---

### 10. TesterArmy E2E — proof it works

🔗 **https://github.com/tester-army/e2e** · ~4.6k stars · Apache-2.0

**What it is.** Next-generation E2E testing: describe a test goal in natural language and an AI agent drives the app (`agent.act('upgrade the workspace to the Pro plan')`), freely mixed with deterministic Playwright locators and assertions. The clever bit: once an agent step runs, its actions are **recorded and replayed with zero model calls** until the app changes — stable regressions cost no tokens.

**How it helps.** It's the verification layer's teeth — Layer 3 says "show evidence," this produces it. The record-and-replay design answers the "AI tests are too expensive to run in CI" objection.

**Where it's useful.** Critical user flows: signup, checkout, upgrades, onboarding — anything where "the unit tests pass" isn't the same as "the product works."

**Install** (per project, never global): `npx e2e init` — asks for engine (web/mobile) and model provider, writes config + an example test.

**Example.**
```ts
// One natural-language step, plus a hard assertion
await agent.act('upgrade the workspace to the Pro plan');
await expect(page.getByText('Pro plan active')).toBeVisible();
```
> First run: the agent drives the browser with model calls. Every run after: recorded actions replay deterministically — zero tokens — until the UI changes.

---

## Also worth knowing

Not in the top 10, but kept on the radar:

- **[alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills)** (~28k stars, MIT) — a mega-library of ~380+ skills across 20 domains: engineering, product, marketing, finance, compliance, even C-level advisor personas. Already vendors Matt Pocock's skills. If you want *everything* including non-coding skills, install this **instead of** #2 — never alongside it.
- **[nidhinjs/prompt-master](https://github.com/nidhinjs/prompt-master)** (~14k stars, MIT) — a skill that writes optimized, token-frugal prompts for 30+ AI tools (Claude, ChatGPT, Codex, Midjourney, Sora…). Handy if you prompt other tools a lot; not a coding-workflow skill, which is why it sits outside the top 10.
- **[darwintechlab/openjev](https://github.com/darwintechlab/openjev)** (brand new, MIT) — an Opencode plugin that replaces LLM judgment calls with deterministic typed decisions (`jev_choice`, `jev_noul`, …). Interesting infrastructure idea, but days old and unproven — flagged experimental, revisit in a few months.

> **Open item:** the original list had a **"4"** I couldn't match to any repo — likely a numbering artifact from a "top 10" post. Send the source and I'll slot the right skill in.

---

## Install everything at once

The agent-executable sequence lives in [`INSTALL.md`](INSTALL.md); the script is [`scripts/install.sh`](scripts/install.sh):

```bash
./scripts/install.sh --agent claude   # or: cursor | codex | copilot | generic
./scripts/install.sh --agent claude --dry-run   # preview first on a new machine
```

Install order is deliberate: **workflow → knowledge → discipline → behavior → design → verify**. `tester-army/e2e` installs per-project — the script prints the command but never runs it globally.

## Push this to GitHub

```bash
git remote add origin https://github.com/aaronjoseph94/aarons-skill-stack.git
git branch -M main
git push -u origin main
```
