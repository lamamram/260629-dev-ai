# OpenCode

> OpenCode est un assistant AI en terminal qui aide les développeurs à écrire le code plus efficacement en utilisant des modèles de langage avancés.

> utilise nativement des outils pour manipuler le système de fichiers, exécuter du code, etc.

> peut se connecter à des outils externes comme mcps ou des plugins personnalisés ou hénergés ailleurs.

> permet d'inejecter des savoir-faire spécifiques à un domaine dans des agents AI.

## :dart: Installation

* [Documentation officielle](https://opencode.ai)

* `npm i -g opencode-ai`
* lancement `opencode`

---

## :dart: premier survol

### :pushpin: modes d'utilisation

* `ctrl + t`: variants: le niveau de réflexion de l'AI
* `ctrl + p`: commandes: liste de paramètres générales (ex: changer de modèle, thème, etc)
* `/<truc>` dans le prompt: permet d'utiliser les **commandes "slash"**
   + /session permet de gérer les != conversations qu'on mène
   + possibilité de créer ses propres commandes "slash"
   + ajouter des "compétences" **skills** à l'AI via des commandes slash ou via des **plugins**
* `!`: permet d'exécuter du code shell dans le prompt

* notion d' **agents**: par défaut 2 "agents"
    + `build`: pour mener une conversation classique (mode agent)
    + `plan`: pour planifier des tâches complexes (mode **planner**)
    + possibilité de créer ses propres agents (primaires ou **sous-agents**)


* en éxaminant la réponse d'un agent: celui nous donne la liste des **tools** qu'il a utilisé pour répondre
  + on peut permettre ou interdire l'utilisation automatique de certains tools
  + on peut ajouter des tools externes: **mcps**

### :pushpin: comportement automatique: formatage

* opencode formate automatiquement les code source qu'il génère en utilisant une famile de formateurs
  + ex: pour python => ruff
  + ex: pour js/ts => prettier

* il suffit d'installer le formateur dans le système avec sa configuration pour qu'opencode l'utilise

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "formatter": {
    "ruff": {
      "command": ["pipx", "run", "--quiet", "ruff", "format", "--config", "app\\.ruff.toml", "app\\"],
      "extensions": [".py"]
    }
  },
  ...
}
```

> :bulb: REM: pipx est un outil qui permet d'installer et exécuter un package pip dans un environnement virtuel à la volée.
> `pip install --user pipx` + `python -m pipx ensurepath` et relancer le terminal.
> mieux: déplacer le `pipx.exe` de `%APPDATA%\Roaming\Python\python3x\Scripts` dans un dossier du PATH => `~\.local\bin`.

---

## :dart: connexion d'OpenCode à un mdèle local avec Ollama

* [doc - ici](https://docs.ollama.com/integrations/opencode#opencode)


### prerequis - la longeur de contexte

#### variables d'environnement

* spécifier une `longeur de contexte` suffisante pour le modèle dans ollama
  + ex: pour qwen3:8b => 16384
  + dans le lancement d'ollama ajouter la variable d'environnement:
    `OLLAMA_DEFAULT_CONTEXT_LENGTH=16384`

* ajouter la variable `OLLAMA_KEEP_ALIVE=30m` pour rendre le modèle plus activé plus longtemps

```bash
docker rm -f ollama
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama --env OLLAMA_CONTEXT_LENGTH=32768 --env OLLAMA_KEEP_ALIVE=30m ollama/ollama
```

#### fichier de modèle

* OU embarquer le changement de paramètre dans un fichier de modèle

```
# Modelfile
FROM qwen3:8b
PARAMETER num_ctx 32768
```
```bash
ollama create qwen3:8b-32k -f Modelfile
ollama rm qwen3:8b
ollama run qwen3:8b-32k
# voir le modelfile complet
olloma show --modelfile qwen3:8b-32k
```

1. pas besoin d'API key ici
2. placer le fichier `~/.config/opencode/config.json` avec le contenu suivant:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama Local",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "qwen3:8b": {
          "name": "qwen3:8b"
        }
      }
    }
  }
}
```

> with tls: baserURL: "https://ollama.local:3000/v1" <br>
> `Import-Certificate -FilePath 'C:\Users\Admin stagiaire.DESKTOP-8967908\Desktop\dawan\dawan_work\dawan_ollama\certs\open-webui.crt' -CertStoreLocation 'Cert:\LocalMachine\Root'`

3. relancer:  `/exit  + opencode`

4. on devrait ollama-local comme provider et qwen3:8b comme modèle sélectionné

> debug command: opencode run "hello. short response" --print-logs --log-level DEBUG --model ollama/qwen3:8b-32k

---

## :dart: charger une api key pour un modèle distant: Ex openrouter

### :pushpin: chargement de la clé 

#### dans opencode

* `/connect` => openrouter
* coller la clé API openrouter => peut occasionner une erreur "destroy editbuffer"

#### dans opencode cli

* `opencode auth ls` => voirs les credentials
* `opencode auth login` => selectionner openrouter et coller la clé API

### :pushpin: choix du modèle

* `/models`

---

## :dart: bootstrap d'un projet avec opencode

> [ doc - ici ](https://opencode.ai/docs/rules/)

* `/init`: va générer un fichier qui s'appelle `AGENTS.md` dans la racine du projet courant
  + **analyse la codebase**
  + détaille des sections expliatives du projet

  > il faut élaguer le fichier AGENTS.md pour ne garder que les parties intéressantes

### :pushîn: subsidiarité du fichier AGENTS.md

* par défaut AGENTS.md est à la racine du projet
  + pour des infos sur le projet

* on peut créer un fichier AGENTS.md pour le compte utilisateur dans `~/.config/opencode/AGENTS.md`
  + pour des infos générales sur le développeur

* on peut créer un fichier AGENTS.md dans un sous-dossier du projet
  + pour des infos spécifiques à ce sous-dossier: ex tests, docs, etc.

---

## :dart: lancer opencode dans un projet existant

* générer un setup

```text
je veux créer une application python fastAPI / sqlAlchemy dans un nouveau dossier app
  ┃  - installer les packages (récents)
  ┃  - modèles SqlAlchemy dans .\app\models
  ┃  - schémas Pydantic dans .\app\schemas
  ┃  - tests pytest dans .\app\tests
  ┃  - une simple route "/" pour dire "hello"
```

* réponse: écriture sans permissions et pas d'exécution
* recommandations
```text
Pour lancer l'application :
     1. Installez les dépendances : pip install -r app/requirements.txt     
     2. Lancez l'application : python app/main.py
     3. Accédez à http://localhost:8000 pour voir "Hello World"
     4. La documentation Swagger est disponible à http://localhost:8000/docs
```

> :warning: REM1: chaque initiative de création/modification de fichiers livrée par opencode doit être validée par l'utilisateur ou infirmée. => **YAGNI**: "You Ain't Gonna Need It"

> :warning: REM2: les assistants ont la mauvaise habitude de fixer les versions des packages.
> sans prendre considérations les compatibilités.
> soit l'utilisateur connaît les versions compatibles ou **soit on laisse pip gérer les versions**.

> :+1: REM3: le fichiers AGENTS.md doivent mis à jour pour refléter les modifications contingents de la vie d'un projet.

---

## :dart: gérer les permissions des outils opencode

> [ doc - ici](https://opencode.ai/docs/permissions/)

* familles de permissions:
  + `allow`: open-bar
  + `ask`: prompt de confirmation
  + `deny`: refus total

* en premier lieu les permissions sont géré dans le fichier de config 
  + global: `~/.config/opencode/config.json`
  + local: `./opencode.json`

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  // règles de préseances, ici:
  // par défaut tout est en "ask"
  // Mais pour read en particulier:
  // par défaut est "allow"
  // sauf pour les fichiers .env qui sont en "deny"
  "permission": {
    "*": "ask",
    "read": {
      "*": "allow",
      "*.env": "deny"
    }
  }
}
```

> :bulb: sur l'interface `ask` on peut demander à autoriser  
> - une seule fois l'action  
> - ou pour toutes le requêtes concerant l'outil et son pattern, dans la session courante

---

## :dart: customiser une commande /slash

* créer un fichier markdown dans `.opencode/commands/` ou dans `~/.config/opencode/commands/`
  + ex: `.opencode/commands/pytest.md`
* exécution humaine

### :pushpin: template de commande slash

```markdown
---
description: <descr>
agent: <agent-name>
model: inherits | <model-name>
permission: {...}

---

## overview

## context

## best practices / antipatterns

## tasks
[ peut utiliser la variable $ARGUMENTS ou les arguments indivuiduels $1, $2, ... ]
1. xxxx
2. yyyy

```


> :bulb: les commandes slash devraient être concises et dédiées à des tâches de maintenance.

> ici /pytest devrait être implémentée avec une skill


---

## :dart: créer une skill pour OpenCode

> [ doc - ici](https://opencode.ai/docs/skills/)

### :pushpin: principe

* une skill est un ensemble de connaissances spécialisées dans un domaine
* placées dans un dossier de nom "<skill-name>" dans:   
  + `~/.config/opencode/skills/` ou
  + `./.opencode/skills/`
* et contant un fichier `SKILL.md` et des ressources annexes

### :pushpin: template de SKILL.md

```markdown
---
[ required ]
name: <skill-name>
description: description précise de la skill pour activer la skill dans le prompt.
[ optional]
license: MIT
compatibility: opencode
metadata: {tags}

---

## overview
[ expliquer en quoi consiste cette skill ]

## procédures

### proc1

1. xxxx
2. yyyy

### proc2

1. zzzz
2. tttt

## When to use me

[ expliquer dans quel contexte cette skill doit être utilisée ]

## commands

[ lister les commandes slash associées à cette skill ]

## best practices

[ expliquer les bonnes pratiques d'utilisation de cette skill ]
consult `./doc-*.md`


```

### :pushpin: autoriser la skill dans opencode

* fichier `opencode.json` du projet
```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    // autorisation d'une skill
    "skill": {
      "<skill-name>": "allow"
    }
  }
}
```

> :+1: REM1: si opencode ne détecte pas la skill en utilisant l'inférence
> alors soit préciser la description
> soit **forcer le chargement** de la skill **dans le prompt** avec la commande

> :warning: il n'y a pas d'entêtes YAML **pour les permissions** dans le fichier SKILL.md
> ce seront les entêtes YAML des agents qui chargeront la skill, qui comprendront les permissions.  

---

## :dart: utiliser des tools externes: MCPS

> [ doc - ici ](https://opencode.ai/docs/mcp-servers/)

### :pushpin: principe

![](./images/mcps.png)

### :pushpin: le protocole MCP

![](./images/mcp-protocol.png)

### :pushpin: exemple en local: context7

* install: [dans npm.js](https://www.npmjs.com/package/@upstash/context7-mcp)
  + `npm i -g @upstash/context7-mcp`

* config dans `opencode.jsonc`:

```jsonc
{
  ...
  "mcp": {
    "context7": {
      "type": "local",
      "command": ["npx", "-y", "@upstash/context7-mcp"],
      "enabled": true
    }
  }
}
```

> :bulb: REM1: `npx` est un outil qui permet d'installer et exécuter un package npm à la volée.
> comme `pipx` pour python avec pip qui ajoute en plus un environnement virtuel à la volée.

> :bulb: REM2: on peut également installer le mcp avec la commande `opencode mcp add`
> qui nous guide vers l'installation et la configuration du mcp au niveau global `~/.config/opencode/opencode.json`. 

### :pushpin: exemple plywright

* [ dans github ](https://github.com/microsoft/playwright-mcp)

* config dans `opencode.jsonc`:

```jsonc
{
  ...
  "playwright": {
      "type": "local",
      "command": [
        "npx",
        "@playwright/mcp@latest"
      ],
      "enabled": true
    }
}
```

> :bulb: REM: un mcp utilsant des images/docker doit consommer plus de ressources(tokens).

### mcp serveur hénergé dans le docker hub

* [docker mcp hub](https://hub.docker.com/mcp)

1. :wrench: se connecter au docker desktop > 4.49: conexion du client **opencode**

![alt text](./images/mcp-docker.png)

2. :wrench: sélectionner un serveur MCP dans le hub

3. :wrench: configurer le conteneur : ici **mcp SQLITE** [doc]( https://github.com/neverinfamous/sqlite-mcp-server/tree/bd3d25248d36685fc049e090d28458cabf6ad617⁠)
  + la conf json est située dans le fichier `./opencode.jsonc`

4. relancer opencode et voir les /MCP_DOCKER et les nouveaux outils dans /mcps

> :bulb: REM: la config du mcp sqlite lié au docker desktop pour opencode est absente

> :bulb: on peut ajouter des mcp docker sans docker desktop
> en utilisant la commande `opencode mcp add` ou en lançant un conteneur docker manuellement
> dans la configuration opencode

```jsonc
{
    ...
    "sqlite":{
      "type":"local",
      // placer la base de donnée sqlite dans le bon dossier
      "command":["docker","run","-i","--rm",
        "-v","./app.db:/workspace/app.db",
        "writenotenow/sqlite-mcp-server",
        "--db-path",
        "/workspace/app.db"
      ]
    }
}
```


---

## :dart: créer ses propres agents OpenCode

[ doc - ici](https://opencode.ai/docs/agents/)


* un agent **primaire** est un assistant AI spécialisé dans un domaine
  + qui interagit avec l'utilisateur

* un agent **sous-agent** est un assistant déclenché par un agent primaire en le préfixant par `@<subagent-name>`
  + pour accomplir une tâche spécifique

* les agents custom sont placés dans `.opencode/agents/` ou dans `~/.config/opencode/agents/`

### :pushpin: template d'agent

* le nom de l'agent est le nom du fichier markdown

```markdown
---
[required]
description: <descr>
mode: <primary | subagent>
[optional]
model: <model-name>
permission:
  edit: deny
  bash: allow
  [activer/desactiver des skills]
  skill:
    pytest_writer: allow

---

## overview

tu es un agent opencode spécialisé dans ...

## context

## procédures utilisants des skills
...

```

### :pushpin: bonnes pratiques avec les sous-agents

* pour lancer plusieurs sous-agents en parallèle
  + il suffit de le demander explicitement dans le prompt
  + il est préférable de spécifier des modèles différents légers pour les sous-agents

> :bulb: REM: les outils aussi peuvent être lancés en concurrence s'il on le demande !!



### :pushpin: atelier: agent tdd

* faire une TDD:

1. ajouter la création de la branch de foncitonnalité avant d'exécuter la tdd dans l'agent
2. créer une skill de developpeur python
   + chercher des skills de ce type sur le web
 
3. (optionnel) ajouter un conteneur jira pour hoster une issue
4. (optionnel) ajouter un mcp pour chercher une issue à partir du prompt
5. (optionnel )câbler le mcp dans l'agent dans le plan de tdd
6. OU l'issue est dans le prompt

#### synthèse de l'agent tdd

1. comprendre les requirements : OK
2. créer une branche de fonctionnalité : OK
3. écrire un squelette de fonctionnalité : OK
4. écrire les tests:
  - manque de précision sur la procédure de test liée à la manipulation des données de test => cleanup des données
  - manque de formatage et de documentation
5. écrire le code de la fonctionnalité: **PAS DE SECURITE !!! à ajouter dans la compétence python_coder**
6. migration des données: OK
7. exécuter les tests : 90% bon
8. commiter les changements : KO un test unitaire a échoué

### :pushpin: démarche en continu

1. commencer avec des petites issues et augmenter la complexité progressivement
2. ne pas passer en mode YOLO (tout autoriser) pour les permissions
  + `todowrite: ask`
3. pas de merge sur le moteur d'intégration continue (gitub / gitlab) sans revue de code
  + on peut pousser dans la branche de fonctionnalité

### améliorations possibles

* le prompt générique de l'agent TDD
  + "exécute un cycle tdd selon l'issue <isuue_id> du repo <git_remote_url> sur mon github" peut être embarquée dans une commande slash `/tdd <issue_id> <git_remote_url>` 

### antipatterns

* exécuter en TUI (Terminal User Interface) et non en CLI: `opencode run --agent tdd "écrire une fonctionnalité qui ..."` serait dangereux