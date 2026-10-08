---
name: engineering-workflow
description: Harness-agnostic engineering workflow for building software with an AI agent: a 10-phase skill sequence (understand → design → plan → build → debug → verify → review → audit → ship) plus 20 copy-paste prompts, one per scenario. Works in Claude Code, Cursor, Codex, DeepSeek, or any other agent — tools with skill support load the named stack skills; tools without follow the written steps. Use when starting any build, or to make every agent on the stack follow the same process.
---

# Engineering Workflow

The orchestration layer for this skill stack: the order the other skills are used in, and a ready prompt for each common scenario.

## Install into a project

Copy the templates from this skill into the project:

- `AGENTS.md` → project root. Entry point for Cursor, Codex, DeepSeek and other non-Claude harnesses. Points at the same rules Claude Code follows, so every harness works the same way.
- `CLAUDE.md` → project root. Project rules file for Claude Code — a starter template; fill in the project's stack, rails that must never break, conventions, and commands.
- `ENGINEERING-WORKFLOW.md` → `docs/`. The workflow itself: the phase sequence and the copy-paste prompts.

## The rule every agent follows

1. Read the project rules file and progress notes first. They override this file where they differ.
2. Name the scenario from `docs/ENGINEERING-WORKFLOW.md` you are following, then load that scenario's skills.
3. Follow the scenario's steps as written. If the tool cannot load the named skills, follow the words instead — every step says what to do.
4. Never claim something works without evidence: paste the command and its real output.
5. Never put a secret in code, a commit, a log or the chat.

## What's inside ENGINEERING-WORKFLOW.md

- **Part 1 — the sequence:** 10 phases (0 Start → 9 Ship), each naming the stack skills to use. Small jobs use a slice — a typo or copy change is just phase 6 (Verify); a bug is 5 → 6 → 7; a small feature is 2 → 4 → 6 → 7; a big feature uses everything.
- **Part 2 — standing rules:** paste once into the rules file or above any prompt. No mid-task questions unless safety, a spec decision, or money is at stake — state the assumption, pick, and record it. Simplest change that works; every changed line traces to the task. Finish with a plain-English summary: what changed, what was decided, what's needed next, what couldn't be verified.
- **Part 3 — prompts by scenario:** 20 fill-in-the-blank prompts — new feature, bug fix, small change, UI/design change, refactor, tests, performance, security review, code review, dependency upgrade, schema change, AI/LLM feature, plan only, research, understand a codebase, production incident, deploy/release, web quality audit, documentation, handoff.

The full sequence and prompts live in `ENGINEERING-WORKFLOW.md` — that file is the source of truth; this SKILL.md is the index.
