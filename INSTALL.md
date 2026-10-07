# INSTALL — agent-executable sequence

This file is written for the coding agent to follow directly. Human alternative: run the script and answer the prompts.

## Run

```bash
./scripts/install.sh --agent <target> [--dry-run] [--project]
```

- `<target>`: `claude` (Claude Code) · `cursor` · `codex` · `copilot` · `generic` (any agent via universal `.agents/skills` format)
- `--dry-run`: print every command without running anything
- `--project`: install into the current project directory instead of user-global (default: global via `-g` where supported)

## What the script does, in order

| Step | Skill | Method |
|------|-------|--------|
| 1 | obra/superpowers | Claude: `claude plugins marketplace add` + install. Others: `npx skills@latest add obra/superpowers` |
| 2 | mattpocock/skills | `npx skills@latest add mattpocock/skills` |
| 3 | addyosmani/agent-skills | `npx skills@latest add addyosmani/agent-skills` |
| 4 | JuliusBrussee/caveman | `npx skills@latest add JuliusBrussee/caveman` |
| 5 | DietrichGebert/ponytail | `npx skills@latest add DietrichGebert/ponytail` |
| 6 | Panniantong/Agent-Reach | `agent-reach install` (interactive; agent reads `docs/install.md` in the repo) |
| 7 | Egonex-AI/Understand-Anything | Claude: marketplace add + install. Others: repo's one-line `install.sh` |
| 8 | nextlevelbuilder/ui-ux-pro-max-skill | `npm install -g ui-ux-pro-max-cli && uipro init --ai <target>` |
| 9 | legions-developer/evilcharts | `npx skills@latest add legions-developer/evilcharts` (components via shadcn when building) |
| 10 | pbakaus/impeccable | `npx impeccable install --scope=global` (or project); then `/impeccable init` in-agent |
| 11 | Nutlope/hallmark | `npx skills add nutlope/hallmark` |
| 12 | Leonxlnx/taste-skill | `npx skills add https://github.com/Leonxlnx/taste-skill` |
| 13 | nykooi1/vibe-wise | Claude only: `/plugin install vibe-wise@anthropic-plugin-directory` (script prints for other agents) |
| 14 | kaankiziltug/logo-design-skill | Claude: marketplace + plugin. Others: clone + copy `skills/logo-design` |
| 15 | echris6/motion-video-kit | Clone + copy `business-motion-film` into Claude/agent skills dir |
| 16 | howseen-ai/claude-motion-design | Clone + copy `skill/motion-design`; pip + Playwright Chromium |
| 17 | feitangyuan/onetake | Clone into `~/.claude/skills/onetake` or `~/.agents/skills/onetake` — **noncommercial license** |
| 18 | tester-army/e2e | ⚠️ **per-project only** — the script prints the command but does not run it: `npx e2e init` inside each project |

## Rules the agent must follow

1. **Dry-run first on a new machine.** Run with `--dry-run`, read the output, then run for real.
2. **Do not install `alirezarezvani/claude-skills` alongside `mattpocock/skills`.** It vendors Pocock's skills — pick one (this stack picks Pocock).
3. **Step 18 is per-project.** Never run `npx e2e init` globally.
4. **Verify each step.** After install, confirm the skill directory exists (`~/.claude/skills/`, `.agents/skills/`, or the target's skills dir) before moving to the next step. Report any step that fails instead of skipping silently.
5. **Interactive steps need the human.** Steps 1 (Claude plugin install), 6, 8, 10, and 13–14 may prompt — if they do, pause and surface the prompt to the user rather than guessing.
6. **onetake is PolyForm Noncommercial.** Do not use it for commercial work without a separate license from the author.
7. **VibeWise is Claude Code–centric.** On Cursor/Codex/Copilot the script notes the limitation; don't invent a broken install path.

## Manual fallback

If the script can't run on a machine, the per-skill install commands are in the [README skill cards](README.md#the-skill-stack), in the same order.
