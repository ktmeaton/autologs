#!/bin/bash

#------------------------------------------------------------------------------
# Input Arguments

# Old version to compare to (default is first commit)
OLD_VER=$1
first_commit=`git log --reverse | head -n 1 | cut -d " " -f2`
OLD_VER=${OLD_VER:=${first_commit}}

# New version to compare to, default is HEAD
NEW_VER=$2
NEW_VER=${NEW_VER:="HEAD"}

# Number of commits to print (default is 20, use -1 for infinite)
MAX_COMMITS=$3
MAX_COMMITS="${MAX_COMMITS:=20}"

#------------------------------------------------------------------------------
# Processing

# Fetch the remote origin url
strip="origin\t\| (push)\|\.git"
origin=`git remote -v | grep -E "origin.*push" | sed "s/$strip//g"`

# Get the base url for commits
base="$origin/commit"

# Counter for commits to print
i=0;

git log --pretty=oneline --abbrev-commit ${OLD_VER}..${NEW_VER} | \
  while read line;
  do
    # Stop printing if max commits has been reached
    if [[ $i -ge $MAX_COMMITS && $MAX_COMMITS != -1 ]]; then
      break
    fi
    hash=`echo $line | cut -d " " -f 1`
    msg=`echo $line | sed "s/$hash //g"`
    echo -e "* [\`\`\`$hash\`\`\`]($base/$hash) $msg";

    # Increment commit counter
    i=`expr $i + 1`
  done;
