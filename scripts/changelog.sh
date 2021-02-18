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


tags=`git tag | tr '\n' ' '`
HEAD="HEAD"
SCRIPTS_DIR="scripts"
NOTES_DIR="docs/releases"
# -1 will impose no restrictions on the number of commits
MAX_COMMITS=-1

#------------------------------------------------------------------------------
# Parse Versions
arr_ver=($BASE $TAGS $HEAD)
num_ver=${#arr_ver[@]}

# An obscure way to reverse a list
arr_ver=(`for ((i=${num_ver}-1; i>=0; i--));  do echo ${arr_ver[$i]}; done | tr '\n' ' '  `)
prev_ver=${arr_ver[0]}
latest_ver=${arr_ver[1]}

#------------------------------------------------------------------------------
# Get New Ver
# By default next ver will be a new patch if not specified
if [[ -z $NEW_VER ]]; then
  arr_latest_ver=( `echo $latest_ver | sed 's/v//g' | tr "." " "` )
  major=${arr_latest_ver[0]}
  minor=${arr_latest_ver[1]}
  patch=${arr_latest_ver[2]}
  NEW_VER="v"$major.$minor.`expr $patch + 1`
fi

#------------------------------------------------------------------------------
# Remove old changelog
new_ver_log=${NOTES_DIR}/"CHANGELOG_"`echo $NEW_VER | sed 's/v//g' | sed 's/\./-/g'`".md"

if [[ -f CHANGELOG.md ]]; then
    echo "CHANGELOG.md will be moved to ${new_ver_log}"
    mv CHANGELOG.md ${new_ver_log}
fi

#------------------------------------------------------------------------------
# Changelog Header
echo -e "# Changelog\n" > CHANGELOG.md

#------------------------------------------------------------------------------
# Write updates
for ((i=1; i<${num_ver}; i++));
do
  cur_ver=${arr_ver[$i]}
  echo "Comparing $cur_ver to $prev_ver"
  ${SCRIPTS_DIR}/release.sh ${cur_ver} ${prev_ver} $MAX_COMMITS >> CHANGELOG.md
  prev_ver=$cur_ver
done