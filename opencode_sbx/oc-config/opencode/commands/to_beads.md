---
description: create beads issues from yaml structure 
agent: plan
model: github-copilot/claude-haiku-4.5 
---

1. read `./plan.yml` at the root of the project
2. use /beads:create to create open issues in the yml file, with title, type, description, and children issues if exist

