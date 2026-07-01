---
description: développeur nuxt. utilise la skill nuxt-ui, le mcp context7 pour implémenter et tester des issues beads
mode: subagent
model: opencode-go/qwen3.7-plus
temperature: 0.1
permission:
  edit:
    "*": ask
    "*.js": allow
    "*.ts": allow
  bash:
    "*": deny
    "git diff*": allow
    "git log*": allow
    "grep *": allow
    "npm *": allow
  glob: ask
  grep: ask
  question: deny
  todo: allow
  task: allow
  skill:
    "*": deny
    "nuxt-ui": allow
  webfetch: deny
  # gestion "fine" d'un mcp github
  github_*: deny
  github_lists_*: allow
  github_pull_request_*: allow
  github_issue_read: allow
  github_push_files: allow

---

tu est un développement javascript / typescript. tu utilises la skill nuxt-ui et le mcp context7 pour implémeenter des issues beads

