#!/bin/bash

deploy_option=$1
itchio_repo=$2

should_deploy=0

if [ ! -z "$deploy_option" ]; then
    if [ "$deploy_option" != "--publish" ] || [ -z "$itchio_repo" ]; then
        echo "Usage: $0 [--publish itchio_repo_name]"
        exit 1
    fi
    should_deploy=1
fi

godot --headless --export-release Web exports/index.html

if [ $should_deploy -eq 1 ]; then
    tools/butler push ./exports/ "$itchio_repo":web
fi
