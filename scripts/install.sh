#!/usr/bin/env bash
#
# Aaron's Skill Stack installer
# Installs the 19 coding-agent skills from the README, in layer order:
#   standard -> workflow backbone -> knowledge -> discipline -> behavior
#   -> design -> verify -> secure -> ship
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
  run "1/19 obra/superpowers (Claude Code plugin)" \
    bash -c "claude plugins marketplace add obra/superpowers-marketplace && claude plugins install superpowers@superpowers-marketplace"
else
  run "1/19 obra/superpowers (universal skills)" \
    npx skills@latest add obra/superpowers $SCOPE_FLAG
fi

# ------------------------------------------------- steps 2-5: discipline + behavior (universal)
run "2/19 mattpocock/skills (engineering discipline)" \
  npx skills@latest add mattpocock/skills $SCOPE_FLAG

run "3/19 addyosmani/agent-skills (gated lifecycle)" \
  npx skills@latest add addyosmani/agent-skills $SCOPE_FLAG

run "4/19 JuliusBrussee/caveman (token efficiency)" \
  npx skills@latest add JuliusBrussee/caveman $SCOPE_FLAG

run "5/19 DietrichGebert/ponytail (minimalism)" \
  npx skills@latest add DietrichGebert/ponytail $SCOPE_FLAG

# ---------------------------------------------------------------- step 6: Agent-Reach (internet access)
run "6/19 Panniantong/Agent-Reach (internet access)" \
  bash -c "command -v agent-reach >/dev/null && agent-reach install || { echo 'agent-reach CLI not found - install from https://github.com/Panniantong/Agent-Reach then run: agent-reach install'; exit 1; }"
note "If the CLI is missing, install it from the repo README, then run: agent-reach install"

# ------------------------------------------------- step 7: Understand-Anything (codebase knowledge)
if [ "$AGENT" = "claude" ]; then
  run "7/19 Egonex-AI/Understand-Anything (Claude Code plugin)" \
    bash -c "claude plugins marketplace add Egonex-AI/Understand-Anything && claude plugins install understand-anything"
else
  run "7/19 Egonex-AI/Understand-Anything (one-line installer)" \
    bash -c "curl -fsSL https://raw.githubusercontent.com/Egonex-AI/Understand-Anything/main/install.sh | bash -s $AGENT"
fi

# ---------------------------------------------------------------- step 8: morluto/rea (reverse engineering)
run "8/19 morluto/rea (reverse engineering)" \
  npx rea-agents setup
note "Interactive wizard: review the paths and changes it proposes before approving. Optionally wires up Hopper or an existing Ghidra install."

# ---------------------------------------------------------------- step 8: UI/UX Pro Max (design)
run "9/19 nextlevelbuilder/ui-ux-pro-max-skill (design intelligence)" \
  bash -c "npm install -g ui-ux-pro-max-cli && uipro init --ai $AGENT"
note "Requires Node.js and Python 3. Use 'uipro init --ai all' to target every agent at once."

# ---------------------------------------------------------------- step 9: EvilCharts (components)
run "10/19 legions-developer/evilcharts (chart components)" \
  npx skills@latest add legions-developer/evilcharts $SCOPE_FLAG
note "Components themselves install shadcn-style when you build a dashboard (see evilcharts.com)."

# ---------------------------------------------------------------- step 10: taste-skill (anti-slop polish)
run "11/19 Leonxlnx/taste-skill (anti-slop frontend)" \
  npx skills@latest add Leonxlnx/taste-skill $SCOPE_FLAG

# ---------------------------------------------------------------- step 11: diagram-design (diagrams)
if [ "$AGENT" = "claude" ]; then
  run "12/19 cathrynlavery/diagram-design (Claude Code plugin)" \
    bash -c "claude plugins marketplace add cathrynlavery/diagram-design && claude plugins install diagram-design@diagram-design"
else
  run "12/19 cathrynlavery/diagram-design (universal skills)" \
    npx skills@latest add cathrynlavery/diagram-design $SCOPE_FLAG
fi

# ---------------------------------------------------------------- step 12: karpathy guidelines
run "13/19 multica-ai/andrej-karpathy-skills (coding guidelines)" \
  npx skills@latest add multica-ai/andrej-karpathy-skills $SCOPE_FLAG
note "Repo moved orgs: forrestchang/ -> multica-ai/. Use multica-ai/ URLs."

# ---------------------------------------------------------------- step 13: i-have-adhd (action-first output)
run "14/19 ayghri/i-have-adhd (action-first output)" \
  npx skills@latest add ayghri/i-have-adhd $SCOPE_FLAG

# ---------------------------------------------------------------- step 14: cybersecurity skills library
run "15/19 mukul975/Anthropic-Cybersecurity-Skills (security knowledge)" \
  npx skills@latest add mukul975/Anthropic-Cybersecurity-Skills $SCOPE_FLAG

# ---------------------------------------------------------------- step 15: cloudflare security audit
run "16/19 cloudflare/security-audit-skill (security audit workflow)" \
  npx skills@latest add https://github.com/cloudflare/security-audit-skill --skill security-audit $SCOPE_FLAG

# ---------------------------------------------------------------- step 16: claude-seo (growth)
if [ "$AGENT" = "claude" ]; then
  run "17/19 AgriciDaniel/claude-seo (Claude Code plugin)" \
    bash -c "claude plugins marketplace add AgriciDaniel/claude-seo && claude plugins install claude-seo@agricidaniel-claude-seo"
  note "After install, run /seo setup inside Claude Code (interactive)."
else
  echo ""
  echo "==> 17/19 AgriciDaniel/claude-seo (MANUAL - Claude Code is the primary target)"
  echo "    Clone and run the manual installer from https://github.com/AgriciDaniel/claude-seo"
  echo "    or install it in Claude Code with:"
  echo "        /plugin marketplace add AgriciDaniel/claude-seo"
  echo "        /plugin install claude-seo@agricidaniel-claude-seo"
fi

# ---------------------------------------------------------------- step 17: anthropics/skills (the standard)
if [ "$AGENT" = "claude" ]; then
  run "18/19 anthropics/skills (official document skills)" \
    bash -c "claude plugins marketplace add anthropics/skills && claude plugins install document-skills@anthropic-agent-skills"
else
  run "18/19 anthropics/skills (reference)" \
    npx skills@latest add anthropics/skills $SCOPE_FLAG
  note "Document skills (PDF/DOCX/XLSX/PPTX) are Claude-native; other agents get reference value."
fi

# ---------------------------------------------------------------- step 19: tester-army/e2e (per-project - printed only)
echo ""
echo "==> 19/19 tester-army/e2e (PER-PROJECT ONLY - not run)"
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
echo "  4. Before launch: ask the agent to 'security audit this codebase' (Cloudflare audit skill)"
echo "See INSTALL.md for the manual fallback and the rules."
