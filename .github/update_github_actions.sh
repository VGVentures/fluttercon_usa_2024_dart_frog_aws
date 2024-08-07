#!/bin/sh

mason make github_actions_dart --on-conflict overwrite --exclude '' --minCoverage 100 --flutterVersion '3.22.1' --flutterChannel stable --dartChannel stable --dependabotFrequency daily --generateDependabot false --generateSemanticPullRequest true --generateSpellCheck true --spellCheckConfig cspell.json --workflowRef main --generateLicenseCheck false