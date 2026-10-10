#!/usr/bin/env bash
#
# Aaron's Skill Stack installer
# Installs the 27 coding-agent skills from the README, in layer order:
#   orchestration -> standard -> workflow backbone -> knowledge -> discipline
#   -> behavior -> design -> verify -> secure -> ship -> video
#
# Skill #20 (engineering-workflow) lives in this repo and is per-project:
# the script prints the template copy commands but does not install it.
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
#   - tester-army/e2e (19) and engineering-workflow (20) are per-project only: printed, not run
#   - onetake is PolyForm Noncommercial — noncommercial use only
#   - verify each step; report failures, don't skip silently

set -u

AGENT=""
DRY_RUN=0
SCOPE_FLAG="-g"   # npx skills: -g = user-global
SCOPE_NAME="user-global"
IMPECCABLE_SCOPE="global"
SKILLS_HOME="${HOME}/.claude/skills"
AGENTS_HOME="${HOME}/.agents/skills"

for arg in "$@"; do
  case "$arg" in
    --agent=*) AGENT="${arg#*=}" ;;
    --agent) shift; AGENT="${1:-}" ;;
    --dry-run) DRY_RUN=1 ;;
    --project) SCOPE_FLAG=""; SCOPE_NAME="current project"; IMPECCABLE_SCOPE="project" ;;
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

case "$AGENT" in
  claude) IMPECCABLE_PROVIDERS="claude" ;;
  cursor) IMPECCABLE_PROVIDERS="cursor" ;;
  codex) IMPECCABLE_PROVIDERS="codex" ;;
  *) IMPECCABLE_PROVIDERS="cursor,claude,codex" ;;
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
  run "1/27 obra/superpowers (Claude Code plugin)" \
    bash -c "claude plugins marketplace add obra/superpowers-marketplace && claude plugins install superpowers@superpowers-marketplace"
else
  run "1/27 obra/superpowers (universal skills)" \
    npx skills@latest add obra/superpowers $SCOPE_FLAG
fi

# ------------------------------------------------- steps 2-5: discipline + behavior (universal)
run "2/27 mattpocock/skills (engineering discipline)" \
  npx skills@latest add mattpocock/skills $SCOPE_FLAG

run "3/27 addyosmani/agent-skills (gated lifecycle)" \
  npx skills@latest add addyosmani/agent-skills $SCOPE_FLAG

run "4/27 JuliusBrussee/caveman (token efficiency)" \
  npx skills@latest add JuliusBrussee/caveman $SCOPE_FLAG

run "5/27 DietrichGebert/ponytail (minimalism)" \
  npx skills@latest add DietrichGebert/ponytail $SCOPE_FLAG

# ---------------------------------------------------------------- step 6: Agent-Reach (internet access)
run "6/27 Panniantong/Agent-Reach (internet access)" \
  bash -c "command -v agent-reach >/dev/null && agent-reach install || { echo 'agent-reach CLI not found - install from https://github.com/Panniantong/Agent-Reach then run: agent-reach install'; exit 1; }"
note "If the CLI is missing, install it from the repo README, then run: agent-reach install"

# ------------------------------------------------- step 7: Understand-Anything (codebase knowledge)
if [ "$AGENT" = "claude" ]; then
  run "7/27 Egonex-AI/Understand-Anything (Claude Code plugin)" \
    bash -c "claude plugins marketplace add Egonex-AI/Understand-Anything && claude plugins install understand-anything"
else
  run "7/27 Egonex-AI/Understand-Anything (one-line installer)" \
    bash -c "curl -fsSL https://raw.githubusercontent.com/Egonex-AI/Understand-Anything/main/install.sh | bash -s $AGENT"
fi

# ---------------------------------------------------------------- step 8: morluto/rea (reverse engineering)
run "8/27 morluto/rea (reverse engineering)" \
  npx rea-agents setup
note "Interactive wizard: review the paths and changes it proposes before approving. Optionally wires up Hopper or an existing Ghidra install."

# ---------------------------------------------------------------- step 9: UI/UX Pro Max (design)
run "9/27 nextlevelbuilder/ui-ux-pro-max-skill (design intelligence)" \
  bash -c "npm install -g ui-ux-pro-max-cli && uipro init --ai $AGENT"
note "Requires Node.js and Python 3. Use 'uipro init --ai all' to target every agent at once."

# ---------------------------------------------------------------- step 10: EvilCharts (components)
run "10/27 legions-developer/evilcharts (chart components)" \
  npx skills@latest add legions-developer/evilcharts $SCOPE_FLAG
note "Components themselves install shadcn-style when you build a dashboard (see evilcharts.com)."

# ---------------------------------------------------------------- step 11: taste-skill (anti-slop polish)
run "11/27 Leonxlnx/taste-skill (anti-slop frontend)" \
  npx skills@latest add Leonxlnx/taste-skill $SCOPE_FLAG

# ---------------------------------------------------------------- step 12: diagram-design (diagrams)
if [ "$AGENT" = "claude" ]; then
  run "12/27 cathrynlavery/diagram-design (Claude Code plugin)" \
    bash -c "claude plugins marketplace add cathrynlavery/diagram-design && claude plugins install diagram-design@diagram-design"
else
  run "12/27 cathrynlavery/diagram-design (universal skills)" \
    npx skills@latest add cathrynlavery/diagram-design $SCOPE_FLAG
fi

# ---------------------------------------------------------------- step 13: karpathy guidelines
run "13/27 multica-ai/andrej-karpathy-skills (coding guidelines)" \
  npx skills@latest add multica-ai/andrej-karpathy-skills $SCOPE_FLAG
note "Repo moved orgs: forrestchang/ -> multica-ai/. Use multica-ai/ URLs."

# ---------------------------------------------------------------- step 14: i-have-adhd (action-first output)
run "14/27 ayghri/i-have-adhd (action-first output)" \
  npx skills@latest add ayghri/i-have-adhd $SCOPE_FLAG

# ---------------------------------------------------------------- step 15: cybersecurity skills library
run "15/27 mukul975/Anthropic-Cybersecurity-Skills (security knowledge)" \
  npx skills@latest add mukul975/Anthropic-Cybersecurity-Skills $SCOPE_FLAG

# ---------------------------------------------------------------- step 16: cloudflare security audit
run "16/27 cloudflare/security-audit-skill (security audit workflow)" \
  npx skills@latest add https://github.com/cloudflare/security-audit-skill --skill security-audit $SCOPE_FLAG

# ---------------------------------------------------------------- step 17: claude-seo (growth)
if [ "$AGENT" = "claude" ]; then
  run "17/27 AgriciDaniel/claude-seo (Claude Code plugin)" \
    bash -c "claude plugins marketplace add AgriciDaniel/claude-seo && claude plugins install claude-seo@agricidaniel-claude-seo"
  note "After install, run /seo setup inside Claude Code (interactive)."
else
  echo ""
  echo "==> 17/27 AgriciDaniel/claude-seo (MANUAL - Claude Code is the primary target)"
  echo "    Clone and run the manual installer from https://github.com/AgriciDaniel/claude-seo"
  echo "    or install it in Claude Code with:"
  echo "        /plugin marketplace add AgriciDaniel/claude-seo"
  echo "        /plugin install claude-seo@agricidaniel-claude-seo"
fi

# ---------------------------------------------------------------- step 18: anthropics/skills (the standard)
if [ "$AGENT" = "claude" ]; then
  run "18/27 anthropics/skills (official document skills)" \
    bash -c "claude plugins marketplace add anthropics/skills && claude plugins install document-skills@anthropic-agent-skills"
else
  run "18/27 anthropics/skills (reference)" \
    npx skills@latest add anthropics/skills $SCOPE_FLAG
  note "Document skills (PDF/DOCX/XLSX/PPTX) are Claude-native; other agents get reference value."
fi

# ---------------------------------------------------------------- step 19: tester-army/e2e (per-project - printed only)
echo ""
echo "==> 19/27 tester-army/e2e (PER-PROJECT ONLY - not run)"
echo "    Run inside each project that needs E2E tests:"
echo "        npx e2e init"
note "This step is intentionally never run globally."

# ---------------------------------------------------------------- step 20: engineering-workflow (per-project - printed only)
echo ""
echo "==> 20/27 engineering-workflow (PER-PROJECT ONLY - not installed globally)"
echo "    This skill lives in the skill-stack repo. Per project, copy the templates:"
echo "        cp skills/engineering-workflow/AGENTS.md <project>/AGENTS.md"
echo "        cp skills/engineering-workflow/CLAUDE.md <project>/CLAUDE.md   # fill in: stack, rails, conventions, commands"
echo "        mkdir -p <project>/docs && cp skills/engineering-workflow/ENGINEERING-WORKFLOW.md <project>/docs/"
note "Agents then follow docs/ENGINEERING-WORKFLOW.md: name the scenario, load its skills, follow the steps."

# ---------------------------------------------------------------- Design pack (21-24, restored)
run "21/27 pbakaus/impeccable (design commands)" \
  bash -c "npx impeccable install --scope=$IMPECCABLE_SCOPE --providers=$IMPECCABLE_PROVIDERS"
note "After install, run /impeccable init inside the agent. Refresh later with: npx impeccable update"

run "22/27 Nutlope/hallmark (anti-slop design)" \
  npx skills add nutlope/hallmark $SCOPE_FLAG

if [ "$AGENT" = "claude" ]; then
  run "23/27 nykooi1/vibe-wise (learn while building)" \
    bash -c "claude plugins marketplace add nykooi1/vibe-wise && claude plugins install vibe-wise@vibe-wise"
  note "Prefer Anthropic Directory when available: /plugin install vibe-wise@anthropic-plugin-directory"
else
  echo ""
  echo "==> 23/27 nykooi1/vibe-wise (Claude Code plugin — skipped for $AGENT)"
  note "VibeWise is Claude Code–centric. On Claude Code: /plugin install vibe-wise@anthropic-plugin-directory"
fi

if [ "$AGENT" = "claude" ]; then
  run "24/27 kaankiziltug/logo-design-skill (logo identity)" \
    bash -c "claude plugins marketplace add kaankiziltug/logo-design-skill && claude plugins install logo-design@logo-design-skill"
else
  run "24/27 kaankiziltug/logo-design-skill (copy skill folder)" \
    bash -c "TMP=\$(mktemp -d) && git clone --depth 1 https://github.com/kaankiziltug/logo-design-skill.git \"\$TMP/logo-design-skill\" && mkdir -p \"$AGENTS_HOME\" && cp -R \"\$TMP/logo-design-skill/skills/logo-design\" \"$AGENTS_HOME/logo-design\" && rm -rf \"\$TMP\""
  note "Copied to $AGENTS_HOME/logo-design — move into your agent's skills dir if needed (see repo README)."
fi

# ---------------------------------------------------------------- Video pack (25-27, restored)
run "25/27 echris6/motion-video-kit (launch-film craft)" \
  bash -c "TMP=\$(mktemp -d) && git clone --depth 1 https://github.com/echris6/motion-video-kit.git \"\$TMP/mvk\" && mkdir -p \"$SKILLS_HOME\" \"$AGENTS_HOME\" && cp -R \"\$TMP/mvk/business-motion-film\" \"$SKILLS_HOME/business-motion-film\" && cp -R \"\$TMP/mvk/business-motion-film\" \"$AGENTS_HOME/business-motion-film\" && rm -rf \"\$TMP\""
note "Requires ffmpeg/ffprobe for measurement scripts. HyperFrames optional for rendering."

run "26/27 howseen-ai/claude-motion-design (HTML+Playwright+ffmpeg)" \
  bash -c "TMP=\$(mktemp -d) && git clone --depth 1 https://github.com/howseen-ai/claude-motion-design.git \"\$TMP/cmd\" && mkdir -p \"$SKILLS_HOME\" && cp -R \"\$TMP/cmd/skill/motion-design\" \"$SKILLS_HOME/motion-design\" && rm -rf \"\$TMP\" && python3 -m pip install --user playwright imageio-ffmpeg numpy pillow && python3 -m playwright install chromium"
note "Ask for a video or run /motion-design after install."

run "27/27 feitangyuan/onetake (continuous-take films)" \
  bash -c "mkdir -p \"$SKILLS_HOME\" \"$AGENTS_HOME\" && if [ ! -d \"$SKILLS_HOME/onetake/.git\" ]; then git clone --depth 1 https://github.com/feitangyuan/onetake.git \"$SKILLS_HOME/onetake\"; else git -C \"$SKILLS_HOME/onetake\" pull --ff-only; fi && if [ ! -d \"$AGENTS_HOME/onetake/.git\" ]; then git clone --depth 1 https://github.com/feitangyuan/onetake.git \"$AGENTS_HOME/onetake\"; else git -C \"$AGENTS_HOME/onetake\" pull --ff-only; fi"
note "LICENSE: PolyForm Noncommercial 1.0.0 — noncommercial use only unless you obtain a commercial license."

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
echo "  3. Per UI project: /impeccable init  (records product truth in PRODUCT.md)"
echo "  4. Per project needing tests: npx e2e init"
echo "  5. Before launch: ask the agent to 'security audit this codebase' (Cloudflare audit skill)"
echo "See INSTALL.md for the manual fallback and the rules."
