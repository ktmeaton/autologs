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

# if MAX_COMMITS not specified, will use default in notes_commits script
NOTES_DIR=$4
# if NOTES_DIR not specified, will default to docs/releases
NOTES_DIR=${NOTES_DIR:="docs/releases"}

#------------------------------------------------------------------------------
# Processing

# Retrieve the scripts directory (absolute)
scripts_dir="`dirname \"$0\"`"
scripts_dir="`( cd \"$scripts_dir\" && pwd )`"
if [ -z "$scripts_dir" ] ; then
  echo "Scripts directory $scripts_dir is inaccessible"
  exit 1
fi

# Fetch the repo name
strip="origin\t\| (push)\|\.git\|https:\/\/github.com\/"
repo=`git remote -v | grep -E "origin.*push" | sed "s/$strip//g"`

#------------------------------------------------------------------------------
# Version Parsing
if [[ $NEW_VER == "HEAD" ]]; then
  target_ver=$OLD_VER
else
  target_ver=$NEW_VER
fi

arr_ver=(`echo ${target_ver} | sed 's/v//g'  | tr '.' ' '`)
major=${arr_ver[0]}
minor=${arr_ver[1]}
patch=${arr_ver[2]}

if [[ $NEW_VER == "HEAD" ]]; then
  rel="Development"
else
  rel="Release v$major.$minor.$patch"
fi

#------------------------------------------------------------------------------
# Release Header
echo "## ${rel}"
echo

#------------------------------------------------------------------------------
# Notes Header

# If on the head, look at 'next' release notes
if [[ $NEW_VER == "HEAD" ]]; then
  patch=`expr $patch + 1`
fi

target_notes=${NOTES_DIR}/Release_$major-$minor-$patch.md

if [[ -f $target_notes ]]; then
  echo "### Notes"
  echo
  grep -r '[0-9]\. ' $target_notes
  echo
fi

#------------------------------------------------------------------------------
# Pull Requests Header

# Retieve PR hashes
arr_pr_commits=( `git ls-remote origin 'pull/*/head' | awk '{print substr($1,1,7)}' | tr '\n' ' ' ` )
pr_id=( `git ls-remote origin 'pull/*/head' | cut -f 2 | cut -d "/" -f 3 | tr '\n' ' ' ` )
num_pr=${#arr_pr_commits[@]}

# Retrieve commit hashes
arr_new_ver_commits=( $(${scripts_dir}/commits.sh ${OLD_VER} ${NEW_VER} | cut -d '`' -f 4 | tr '\n' ' ') )

# Search for matching PRs
arr_ver_pr=()
for commit in ${arr_new_ver_commits[@]}; do
  for ((i=0; i<num_pr; i++)); do
    pr=${arr_pr_commits[$i]}
    if [[ $pr == $commit ]]; then
      ver_pr=${pr_id[$i]};
      arr_ver_pr=(${arr_ver_pr[@]} $ver_pr)
    fi;
  done
done

# If a pull request was found
if [[ $ver_pr ]]; then
    echo "### Pull Requests"
    echo

  for pr in ${arr_ver_pr[@]}; do
    pr_title=`curl -s https://api.github.com/repos/${REPO}/pulls/2 | grep title | cut -d '"' -f 4 `
    echo "* [\`\`\`pull/${pr}\`\`\`](https://github.com/${REPO}/pull/${pr}) ${pr_title}"
  done
  echo
fi

#------------------------------------------------------------------------------
# Commits Header
echo "### Commits"
echo
${scripts_dir}/commits.sh ${OLD_VER} ${NEW_VER} ${MAX_COMMITS}
echo
