# Aaron's skill stack

Curated Cursor / agent skills for shipping, E2E testing, PR workflow, and TypeSafe-compatible System One decisions via Codiv OpenJev.

## Install (Cursor)

```bash
npx skills add aaronjoseph94/aarons-skill-stack -g -a cursor -y
```

Or install a single skill:

```bash
npx skills add aaronjoseph94/aarons-skill-stack --skill typesafe-ai -g -a cursor -y
npx skills add aaronjoseph94/aarons-skill-stack --skill e2e -g -a cursor -y
```

## Skills included

| Skill | Purpose |
| --- | --- |
| `typesafe-ai` | Design System One workflows (Choice / Score / Noul) with live docs |
| `e2e` | Agent-driven end-to-end testing |
| `babysit` | Keep PR / CI work moving |
| `ship-pr` | Ship pull requests |
| `verify` | Verification workflows |
| `writing-pr` | PR writing helpers |

## Codiv OpenJev (default System One backend)

This stack expects Codiv, not `api.typesafe.ai`.

```bash
# Windows (PowerShell, user scope)
[Environment]::SetEnvironmentVariable('TYPESAFE_BASE_URL', 'https://api.codiv.ai', 'User')
[Environment]::SetEnvironmentVariable('TYPESAFE_API_KEY', 'sk-codiv-...', 'User')

# macOS / Linux
export TYPESAFE_BASE_URL=https://api.codiv.ai
export TYPESAFE_API_KEY=sk-codiv-...
```

```bash
pip install typesafe-sdk
```

Default model: `openjev-latest` (`jev-latest` aliases to OpenJev on Codiv).

Cursor rule template: [`.cursor/rules/codiv-typesafe.mdc`](.cursor/rules/codiv-typesafe.mdc)

Docs: [Codiv quickstart](https://codiv.ai/docs/quickstart.md) · [Jev compatibility](https://codiv.ai/docs/guides/jev-compatibility)

## Security

Never commit API keys. Use environment variables or local `.env` (gitignored). Rotate any key that has been pasted into chat.
