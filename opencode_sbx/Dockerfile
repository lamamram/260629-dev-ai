# avec ubuntu: regarder https://docs.docker.com/ai/sandboxes/agents/opencode/
FROM node:22-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        git \
        ca-certificates \
        gnupg2 \ 
        pass \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai

COPY open-webui.crt /usr/local/share/ca-certificates
RUN update-ca-certificates

USER node
WORKDIR /home/node
ENV PATH="/home/node/.local/bin:${PATH}"

# installation de beads: local issue tracker to persist oc sessions
RUN curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash

COPY --chown=node:node .bash_profile /home/node/.bash_profile
COPY --chown=node:node .bashrc /home/node/.bashrc
COPY --chown=node:node .git-completion.bash /home/node/.git-completion.bash
COPY --chown=node:node .bash_aliases /home/node/.bash_aliases
COPY --chown=node:node entrypoint.sh /home/node/entrypoint.sh
RUN chmod +x /home/node/entrypoint.sh

## usage de token / sessions | models / monthly
RUN npx tokscale@latest


RUN gpg2 --quick-gen-key --batch --passphrase roottoor oc@tui.lan
RUN pass init $(gpg2 --list-keys | grep -oE "[A-F0-9]+$")

WORKDIR /work


ENTRYPOINT ["/home/node/entrypoint.sh"]
CMD ["opencode"]
