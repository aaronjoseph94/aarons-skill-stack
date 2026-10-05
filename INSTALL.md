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
| 8 | nextlevelbuilder/ui-ux-pro-max-skill | `npm install -g ui-ux-pro-max-cli && uipro init --ai <target>` |
| 9 | legions-developer/evilcharts | `npx skills@latest add legions-developer/evilcharts` (components via shadcn when building) |
| 10 | tester-army/e2e | ⚠️ **per-project only** — the script prints the command but does not run it: `npx e2e init` inside each project |

## Rules the agent must follow

1. **Dry-run first on a new machine.** Run with `--dry-run`, read the output, then run for real.
2. **Do not install `alirezarezvani/claude-skills` alongside `mattpocock/skills`.** It vendors Pocock's skills — pick one (this stack picks Pocock).
3. **Step 10 is per-project.** Never run `npx e2e init` globally.
4. **Verify each step.** After install, confirm the skill directory exists (`~/.claude/skills/`, `.agents/skills/`, or the target's skills dir) before moving to the next step. Report any step that fails instead of skipping silently.
5. **Interactive steps need the human.** Steps 1 (Claude plugin install), 6, and 8 may prompt — if they do, pause and surface the prompt to the user rather than guessing.

## Manual fallback

If the script can't run on a machine, the per-skill install commands are in the [README skill cards](README.md#skill-cards--what-each-does-and-why-its-here), in the same order.
