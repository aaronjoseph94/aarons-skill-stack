#!/usr/bin/env bash
#
# Aaron's Skill Stack installer
# Installs the Top 10 coding-agent skills from the README, in layer order:
#   workflow backbone -> knowledge -> discipline -> behavior -> design -> verify
#
# Usage:
#   ./scripts/install.sh --agent <claude|cursor|codex|copilot|generic> [--dry-run] [--project]
#
#   --dry-run   print commands without running them
#   --project   install into current project dir instead of user-global (default: global)
#
# Rules (from INSTALL.md):
#   - dry-run first on a new machine
#   - never install alirezarezvani/claude-skills alongside mattpocock/skills
#   - tester-army/e2e is per-project only: printed, not run
#   - verify each step; report failures, don't skip silently

set -u

AGENT=""
DRY_RUN=0
SCOPE_FLAG="-g"   # npx skills: -g = user-global
SCOPE_NAME="user-global"

for arg in "$@"; do
  case "$arg" in
    --agent=*) AGENT="${arg#*=}" ;;
    --agent) shift; AGENT="${1:-}" ;;
    --dry-run) DRY_RUN=1 ;;
    --project) SCOPE_FLAG=""; SCOPE_NAME="current project" ;;
    *) ;;
  esac
  shift 2>/dev/null || shift
done

case "$AGENT" in
  claude|cursor|codex|copilot|generic) ;;
  *)
    echo "Usage: $0 --agent <claude|cursor|codex|copilot|generic> [--dry-run] [--project]"
    exit 1 ;;
esac

FAILED=()

run() {
  # run <description> <command...>
  local desc="$1"; shift
  echo ""
  echo "==> $desc"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "    [dry-run] $*"
    return 0
  fi
  if "$@" ; then
    echo "    ok"
  else
    echo "    FAILED: $desc"
    FAILED+=("$desc")
  fi
}

note() { echo "    note: $*"; }

echo "Aaron's Skill Stack installer"
echo "target agent : $AGENT"
echo "scope        : $SCOPE_NAME"
[ "$DRY_RUN" -eq 1 ] && echo "mode         : DRY RUN (nothing will be executed)"

# ---------------------------------------------------------------- step 1: superpowers (workflow backbone)
if [ "$AGENT" = "claude" ]; then
  run "1/10 obra/superpowers (Claude Code plugin)" \
    bash -c "claude plugins marketplace add obra/superpowers-marketplace && claude plugins install superpowers@superpowers-marketplace"
else
  run "1/10 obra/superpowers (universal skills)" \
    npx skills@latest add obra/superpowers $SCOPE_FLAG
fi

# ------------------------------------------------- steps 2-5: universal skills via skills.sh
run "2/10 mattpocock/skills (engineering discipline)" \
  npx skills@latest add mattpocock/skills $SCOPE_FLAG

run "3/10 addyosmani/agent-skills (gated lifecycle)" \
  npx skills@latest add addyosmani/agent-skills $SCOPE_FLAG

run "4/10 JuliusBrussee/caveman (token efficiency)" \
  npx skills@latest add JuliusBrussee/caveman $SCOPE_FLAG

run "5/10 DietrichGebert/ponytail (minimalism)" \
  npx skills@latest add DietrichGebert/ponytail $SCOPE_FLAG

# ---------------------------------------------------------------- step 6: Agent-Reach (internet access)
run "6/10 Panniantong/Agent-Reach (internet access)" \
  bash -c "command -v agent-reach >/dev/null && agent-reach install || { echo 'agent-reach CLI not found - install from https://github.com/Panniantong/Agent-Reach then run: agent-reach install'; exit 1; }"
note "If the CLI is missing, install it from the repo README, then run: agent-reach install"

# ------------------------------------------------- step 7: Understand-Anything (codebase knowledge)
if [ "$AGENT" = "claude" ]; then
  run "7/10 Egonex-AI/Understand-Anything (Claude Code plugin)" \
    bash -c "claude plugins marketplace add Egonex-AI/Understand-Anything && claude plugins install understand-anything"
else
  run "7/10 Egonex-AI/Understand-Anything (one-line installer)" \
    bash -c "curl -fsSL https://raw.githubusercontent.com/Egonex-AI/Understand-Anything/main/install.sh | bash -s $AGENT"
fi

# ---------------------------------------------------------------- step 8: UI/UX Pro Max (design)
run "8/10 nextlevelbuilder/ui-ux-pro-max-skill (design intelligence)" \
  bash -c "npm install -g ui-ux-pro-max-cli && uipro init --ai $AGENT"
note "Requires Node.js and Python 3. Use 'uipro init --ai all' to target every agent at once."

# ---------------------------------------------------------------- step 9: EvilCharts (components)
run "9/10 legions-developer/evilcharts (chart components)" \
  npx skills@latest add legions-developer/evilcharts $SCOPE_FLAG
note "Components themselves install shadcn-style when you build a dashboard (see evilcharts.com)."

# ---------------------------------------------------------------- step 10: tester-army/e2e (per-project - printed only)
echo ""
echo "==> 10/10 tester-army/e2e (PER-PROJECT ONLY - not run)"
echo "    Run inside each project that needs E2E tests:"
echo "        npx e2e init"
note "This step is intentionally never run globally."

# ---------------------------------------------------------------- summary
echo ""
echo "==================== SUMMARY ===================="
if [ "${#FAILED[@]}" -eq 0 ]; then
  echo "All steps completed."
else
  echo "These steps FAILED - investigate before continuing:"
  for f in "${FAILED[@]}"; do echo "  - $f"; done
  exit 2
fi
echo ""
echo "Next:"
echo "  1. In a fresh agent session, confirm skills loaded (e.g. ask the agent to list its skills)."
echo "  2. Per repo, run: /understand  (Understand-Anything builds the knowledge graph)"
echo "  3. Per project needing tests: npx e2e init"
echo "See INSTALL.md for the manual fallback and the rules."
