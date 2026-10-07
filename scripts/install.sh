#!/usr/bin/env bash
#
# Aaron's Skill Stack installer
# Installs the skill stack from the README, in layer order:
#   workflow → knowledge → discipline → behavior → design → video → verify
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
  run "1/18 obra/superpowers (Claude Code plugin)" \
    bash -c "claude plugins marketplace add obra/superpowers-marketplace && claude plugins install superpowers@superpowers-marketplace"
else
  run "1/18 obra/superpowers (universal skills)" \
    npx skills@latest add obra/superpowers $SCOPE_FLAG
fi

# ------------------------------------------------- steps 2-5: universal skills via skills.sh
run "2/18 mattpocock/skills (engineering discipline)" \
  npx skills@latest add mattpocock/skills $SCOPE_FLAG

run "3/18 addyosmani/agent-skills (gated lifecycle)" \
  npx skills@latest add addyosmani/agent-skills $SCOPE_FLAG

run "4/18 JuliusBrussee/caveman (token efficiency)" \
  npx skills@latest add JuliusBrussee/caveman $SCOPE_FLAG

run "5/18 DietrichGebert/ponytail (minimalism)" \
  npx skills@latest add DietrichGebert/ponytail $SCOPE_FLAG

# ---------------------------------------------------------------- step 6: Agent-Reach (internet access)
run "6/18 Panniantong/Agent-Reach (internet access)" \
  bash -c "command -v agent-reach >/dev/null && agent-reach install || { echo 'agent-reach CLI not found - install from https://github.com/Panniantong/Agent-Reach then run: agent-reach install'; exit 1; }"
note "If the CLI is missing, install it from the repo README, then run: agent-reach install"

# ------------------------------------------------- step 7: Understand-Anything (codebase knowledge)
if [ "$AGENT" = "claude" ]; then
  run "7/18 Egonex-AI/Understand-Anything (Claude Code plugin)" \
    bash -c "claude plugins marketplace add Egonex-AI/Understand-Anything && claude plugins install understand-anything"
else
  run "7/18 Egonex-AI/Understand-Anything (one-line installer)" \
    bash -c "curl -fsSL https://raw.githubusercontent.com/Egonex-AI/Understand-Anything/main/install.sh | bash -s $AGENT"
fi

# ---------------------------------------------------------------- step 8: UI/UX Pro Max (design)
run "8/18 nextlevelbuilder/ui-ux-pro-max-skill (design intelligence)" \
  bash -c "npm install -g ui-ux-pro-max-cli && uipro init --ai $AGENT"
note "Requires Node.js and Python 3. Use 'uipro init --ai all' to target every agent at once."

# ---------------------------------------------------------------- step 9: EvilCharts (components)
run "9/18 legions-developer/evilcharts (chart components)" \
  npx skills@latest add legions-developer/evilcharts $SCOPE_FLAG
note "Components themselves install shadcn-style when you build a dashboard (see evilcharts.com)."

# ---------------------------------------------------------------- Design pack (10-14)
run "10/18 pbakaus/impeccable (design commands)" \
  bash -c "npx impeccable install --scope=$IMPECCABLE_SCOPE --providers=$IMPECCABLE_PROVIDERS"
note "After install, run /impeccable init inside the agent. Refresh later with: npx impeccable update"

run "11/18 Nutlope/hallmark (anti-slop design)" \
  npx skills add nutlope/hallmark $SCOPE_FLAG

run "12/18 Leonxlnx/taste-skill (anti-slop frontend)" \
  npx skills add https://github.com/Leonxlnx/taste-skill $SCOPE_FLAG

if [ "$AGENT" = "claude" ]; then
  run "13/18 nykooi1/vibe-wise (learn while building)" \
    bash -c "claude plugins marketplace add nykooi1/vibe-wise && claude plugins install vibe-wise@vibe-wise"
  note "Prefer Anthropic Directory when available: /plugin install vibe-wise@anthropic-plugin-directory"
else
  echo ""
  echo "==> 13/18 nykooi1/vibe-wise (Claude Code plugin — skipped for $AGENT)"
  note "VibeWise is Claude Code–centric. On Claude Code: /plugin install vibe-wise@anthropic-plugin-directory"
fi

if [ "$AGENT" = "claude" ]; then
  run "14/18 kaankiziltug/logo-design-skill (logo identity)" \
    bash -c "claude plugins marketplace add kaankiziltug/logo-design-skill && claude plugins install logo-design@logo-design-skill"
else
  run "14/18 kaankiziltug/logo-design-skill (copy skill folder)" \
    bash -c "TMP=\$(mktemp -d) && git clone --depth 1 https://github.com/kaankiziltug/logo-design-skill.git \"\$TMP/logo-design-skill\" && mkdir -p \"$AGENTS_HOME\" && cp -R \"\$TMP/logo-design-skill/skills/logo-design\" \"$AGENTS_HOME/logo-design\" && rm -rf \"\$TMP\""
  note "Copied to $AGENTS_HOME/logo-design — move into your agent's skills dir if needed (see repo README)."
fi

# ---------------------------------------------------------------- Video pack (15-17)
run "15/18 echris6/motion-video-kit (launch-film craft)" \
  bash -c "TMP=\$(mktemp -d) && git clone --depth 1 https://github.com/echris6/motion-video-kit.git \"\$TMP/mvk\" && mkdir -p \"$SKILLS_HOME\" \"$AGENTS_HOME\" && cp -R \"\$TMP/mvk/business-motion-film\" \"$SKILLS_HOME/business-motion-film\" && cp -R \"\$TMP/mvk/business-motion-film\" \"$AGENTS_HOME/business-motion-film\" && rm -rf \"\$TMP\""
note "Requires ffmpeg/ffprobe for measurement scripts. HyperFrames optional for rendering."

run "16/18 howseen-ai/claude-motion-design (HTML+Playwright+ffmpeg)" \
  bash -c "TMP=\$(mktemp -d) && git clone --depth 1 https://github.com/howseen-ai/claude-motion-design.git \"\$TMP/cmd\" && mkdir -p \"$SKILLS_HOME\" && cp -R \"\$TMP/cmd/skill/motion-design\" \"$SKILLS_HOME/motion-design\" && rm -rf \"\$TMP\" && python3 -m pip install --user playwright imageio-ffmpeg numpy pillow && python3 -m playwright install chromium"
note "Ask for a video or run /motion-design after install."

run "17/18 feitangyuan/onetake (continuous-take films)" \
  bash -c "mkdir -p \"$SKILLS_HOME\" \"$AGENTS_HOME\" && if [ ! -d \"$SKILLS_HOME/onetake/.git\" ]; then git clone --depth 1 https://github.com/feitangyuan/onetake.git \"$SKILLS_HOME/onetake\"; else git -C \"$SKILLS_HOME/onetake\" pull --ff-only; fi && if [ ! -d \"$AGENTS_HOME/onetake/.git\" ]; then git clone --depth 1 https://github.com/feitangyuan/onetake.git \"$AGENTS_HOME/onetake\"; else git -C \"$AGENTS_HOME/onetake\" pull --ff-only; fi"
note "LICENSE: PolyForm Noncommercial 1.0.0 — noncommercial use only unless you obtain a commercial license."

# ---------------------------------------------------------------- step 18: tester-army/e2e (per-project - printed only)
echo ""
echo "==> 18/18 tester-army/e2e (PER-PROJECT ONLY - not run)"
echo "    Run inside each project that needs E2E tests:"
echo "        npx e2e init"
note "This step is intentionally never run globally."

# ---------------------------------------------------------------- summary
echo ""
echo "==================== SUMMARY ===================="
if [ "${#FAILED[@]}" -eq 0 ]; then
  echo "All steps completed (or noted)."
else
  echo "These steps FAILED - investigate before continuing:"
  for f in "${FAILED[@]}"; do echo "  - $f"; done
  exit 2
fi
echo ""
echo "Next:"
echo "  1. In a fresh agent session, confirm skills loaded (e.g. ask the agent to list its skills)."
echo "  2. Per repo, run: /understand  (Understand-Anything builds the knowledge graph)"
echo "  3. Per UI project: /impeccable init"
echo "  4. Per project needing tests: npx e2e init"
echo "See INSTALL.md for the manual fallback and the rules."
