# LD-Base

This repository contains a template Godot 3 game.

As Ludum Daron team, regularly contesting in Ludum Dare gamejam, we use this template to start the event with a minimal code.

## Git hooks

Please install the git hooks by running:
```sh
./setup.sh
```

It requires you to install gdtoolkit. Here is a quick start:
```sh
python3 -m venv .env
source .env/bin/activate
pip install -r requirements.txt
```

Check the [gdlint doc](https://github.com/Scony/godot-gdscript-toolkit/wiki/3.-Linter) for more details.

## Deploy script

**Warning:** requires [dotslash](https://dotslash-cli.com/).

You can build and deploy to itchio using:
```bash
deploy.sh --publish [itchio repo name]
```
