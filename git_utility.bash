#!/bin/bash

gpf() {
  git push --force
}

gpu() {
  git push -u origin $(git_branch_simple)
}

git_branch_simple() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

isTrue() {
  [ -z "$1" ] && { return 1; }
  [ "$1" = "true" ] && { return 0; }
  return 1
}

git_pr() {
  local currentBranch orgAndProject orgAndProjectRegex target result

  currentBranch=$(git_branch_simple)
  target=${1?Missing target branch}
  orgAndProjectRegex='[ ]*Fetch URL: git@github\.com:([^.]+)\.git$'

  [[ "$(git remote show origin | egrep "Fetch URL: ")" =~ $orgAndProjectRegex ]] || {
    printf 'No remote found for "origin"\n'
    return 1
  }
  orgAndProject="${BASH_REMATCH[1]}"

  result="$(curl -X POST \
     -H "Content-Type:application/json" \
     -H "Accept:application/json" \
     -H "Authorization:Bearer $GITHUB_TOKEN" \
     -d \
  "{
    \"title\": \"$(git log --pretty=format:'%s' -1)\",
    \"head\": \"$currentBranch\",
    \"base\": \"$target\"
  }" \
  "https://api.github.com/repos/$orgAndProject/pulls")"

  if isTrue "$(jq 'has("html_url")' <<< "$result")"; then
    printf '\n%s\n' "$(jq -r ".html_url" <<< "$result")"

  elif isTrue "$(jq 'has("errors")' <<< "$result")"; then
    printf '\n%s\n' "$(jq -r '.errors[0].message' <<< "$result")"
    return 1

  else
    printf '\nCannot create PR for unknown reason, server returned:\n"%s"\n' "$result"
    return 1

  fi
}
