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
RUN npm install -g varlock

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER node
WORKDIR /home/node

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/node/.local/bin:${PATH}"

ENV UV_PROJECT_ENVIRONMENT=/home/node/venv \
    UV_PYTHON_INSTALL_DIR=/home/node/.python \
    UV_CACHE_DIR=/home/node/.cache/uv \
    UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1

RUN mkdir -p /home/node/venv /home/node/.cache/uv

RUN uv python install 3.13 --default

RUN curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
#RUN bd init

COPY --chown=node:node .bash_profile /home/node/.bash_profile
COPY --chown=node:node .bashrc /home/node/.bashrc
COPY --chown=node:node .git-completion.bash /home/node/.git-completion.bash
COPY --chown=node:node .bash_aliases /home/node/.bash_aliases

## usage de token / sessions | models / monthly
RUN npx tokscale@latest


RUN gpg2 --quick-gen-key --batch --passphrase roottoor oc@tui.lan
RUN pass init $(gpg2 --list-keys | grep -oE "[A-F0-9]+$")

WORKDIR /work


ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["opencode"]
