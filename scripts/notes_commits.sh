#!/bin/bash

OLD_VER=$1
# Default is the first commit
first_commit=`git log -r | head -n 1 | cut -d " " -f2`
OLD_VER="$OLD_VER:=${first_commit}}"

echo $OLD_VER
exit

NEW_VER=$2
# Default number of commits to print is 20 (use -1 for infinite)
MAX_COMMITS=$3
MAX_COMMITS="${MAX_COMMITS:=20}"

# Fetch the remote origin url
origin=`git remote -v | grep -E "origin.*push" | sed 's/origin\t//g' | sed 's/ (push)//g' | sed 's/\.git//g'`
# Get the base url for commits
base="$origin/commit"

# Counter for commits to print
i=0;

git log --pretty=oneline --abbrev-commit ${OLD_VER}..${NEW_VER} | \
  while read line;
  do
    if [[ $i -ge $MAX_COMMITS && $MAX_COMMITS != -1 ]]; then
      break
    fi
    hash=`echo $line | cut -d " " -f 1`
    msg=`echo $line | sed "s/$hash //g"`
    echo -e "* [\`\`\`$hash\`\`\`]($BASE/$hash) $msg";

    # Increment commit counter
    i=`expr $i + 1`
  done;
