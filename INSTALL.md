# INSTALL — agent-executable sequence

This file is written for the coding agent to follow directly. Human alternative: run the script and answer the prompts.

## Run

```bash
./scripts/install.sh --agent <target> [--dry-run] [--global]
```

- `<target>`: `claude` (Claude Code) · `cursor` · `codex` · `copilot` · `generic` (any agent via universal `.agents/skills` format)
- `--dry-run`: print every command without running anything
- `--global` (default): install to your user folder so every project gets the skills. Without it, installs into the current project directory.

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
| 8 | morluto/rea | `npx rea-agents setup` (interactive; optionally wires up Hopper or an existing Ghidra install) |
| 9 | nextlevelbuilder/ui-ux-pro-max-skill | `npm install -g ui-ux-pro-max-cli && uipro init --ai <target>` |
| 10 | legions-developer/evilcharts | `npx skills@latest add legions-developer/evilcharts` (components via shadcn when building) |
| 11 | Leonxlnx/taste-skill | `npx skills@latest add Leonxlnx/taste-skill` |
| 12 | cathrynlavery/diagram-design | Claude: marketplace add + install. Others: `npx skills@latest add cathrynlavery/diagram-design` |
| 13 | multica-ai/andrej-karpathy-skills | `npx skills@latest add multica-ai/andrej-karpathy-skills` |
| 14 | ayghri/i-have-adhd | `npx skills@latest add ayghri/i-have-adhd` |
| 15 | mukul975/Anthropic-Cybersecurity-Skills | `npx skills@latest add mukul975/Anthropic-Cybersecurity-Skills` |
| 16 | cloudflare/security-audit-skill | `npx skills@latest add https://github.com/cloudflare/security-audit-skill --skill security-audit` |
| 17 | AgriciDaniel/claude-seo | Claude: marketplace add + install (then `/seo setup`). Others: manual (see README card) |
| 18 | anthropics/skills | Claude: marketplace add + install document-skills. Others: `npx skills@latest add anthropics/skills` |
| 19 | tester-army/e2e | ⚠️ **per-project only** — the script prints the command but does not run it: `npx e2e init` inside each project |
| 20 | engineering-workflow (this repo) | ⚠️ **per-project only** — the script prints the template copy commands: `AGENTS.md` → project root, `ENGINEERING-WORKFLOW.md` → `docs/`, `CLAUDE.md` → project root (fill in) |

## Rules the agent must follow

1. **Dry-run first on a new machine.** Run with `--dry-run`, read the output, then run for real.
2. **Do not install `alirezarezvani/claude-skills` alongside `mattpocock/skills`.** It vendors Pocock's skills — pick one (this stack picks Pocock).
3. **Steps 19 and 20 are per-project.** Never run `npx e2e init` globally; copy the workflow templates per project instead of installing them.
4. **Verify each step.** After install, confirm the skill directory exists (`~/.claude/skills/`, `.agents/skills/`, or the target's skills dir) before moving to the next step. Report any step that fails instead of skipping silently.
5. **Interactive steps need the human.** Steps 1, 7, 12, 17, and 18 (Claude plugin installs) plus steps 6 and 8 may prompt — if they do, pause and surface the prompt to the user rather than guessing.

## Manual fallback

If the script can't run on a machine, the per-skill install commands are in the [README skill cards](README.md#the-stack--20-skills), in the same order.
