#!/bin/bash

#------------------------------------------------------------------------------
# Constants

VERSION=0.1.0

# Defaults
FIRST_COMMIT=`git log --reverse | head -n 1 | cut -d " " -f2`
OLD_VER=`echo ${FIRST_COMMIT:0:7}`
NEW_VER="HEAD"
MAX_COMMITS=20
NOTES_DIR="docs/notes"
RUN_FLAG="ListParams"
OUT_FILE="/dev/stdout"


COMMIT_STRIP="origin\t\| (push)\|\.git"
COMMIT_URL=`git remote -v | grep -E "origin.*push" | sed "s/$COMMIT_STRIP//g"`/"commit"
REPO_STRIP="origin\t\| (push)\|\.git\|https:\/\/github.com\/"
REPO=`git remote -v | grep -E "origin.*push" | sed "s/$REPO_STRIP//g"`

# Parse Tags
TAGS=`git tag | tr '\n' ' '`
ARR_TAGS=($FIRST_COMMIT $TAGS "HEAD")
NUM_TAGS=${#ARR_TAGS[@]}

# An obscure way to reverse a list
ARR_TAGS=(`for ((i=${NUM_TAGS}-1; i>=0; i--));  do echo ${ARR_TAGS[$i]}; done | tr '\n' ' '  `)


#------------------------------------------------------------------------------
# Retrieve the absolute path of the executing script
AbsPath()
{
  # Retrieve the scripts directory (absolute)
  autologs_dir="`dirname \"$0\"`"
  autologs_dir="`( cd \"$autologs_dir\" && pwd )`"
  if [ -z "$autologs_dir" ] ; then
    echo " Directory $autologs_dir is inaccessible"
    exit 1
  fi
  echo $autologs_dir
}

AUTOLOGS_DIR=`AbsPath`;

#------------------------------------------------------------------------------
Help()
{
  # Display Help
  # Credits: https://opensource.com/article/19/12/help-bash-program
  # Display Help
  echo "Automatically create commit history, release notes, and a changelog."
  echo
  echo "Syntax: autologs [-h|-v|-o|--old-ver|--new-ver|--max-commits|--notes-dir|--commits|--release]"
  echo
  echo "Options:"
  echo -e "\t-h, --help        Print this Help."
  echo -e "\t-v, --version     Print software version and exit."
  echo -e "\t-o, --output      Output file.                                [ default:" $OUT_FILE "]"
  echo -e "\t--old-ver         An earlier tag/commit hash to compare to.   [ default:" $OLD_VER "]"
  echo -e "\t--new-ver         A newer tag/commit hash to compare to.      [ default:" $NEW_VER "]"  
  echo -e "\t--max-commits     The maximum number of commits to print.     [ default:" $MAX_COMMITS "]"
  echo -e "\t--notes-dir       A directory containing manual notees.       [ default:" $NOTES_DIR "]"
  echo -e "\t--commits         Print commit history."  
  echo -e "\t--release         Print release notes."
  echo -e "\t--changelog       Print changelog."  
  echo
}

#------------------------------------------------------------------------------
Version()
{
  # Display Version
  echo "$VERSION"
}

#------------------------------------------------------------------------------
ListParams()
{
  echo
  echo "Creating Auto $RUN_FLAG with the following parameters."
  echo -e "\tRepository:      $REPO"
  echo -e "\tCommit URL:      $COMMIT_URL"
  echo -e "\tOld version:     $OLD_VER"
  echo -e "\tNew version:     $NEW_VER"
  echo -e "\tMax Commits:     $MAX_COMMITS"
  echo -e "\tNotes Directory: $NOTES_DIR"
  echo -e "\tOutput File:     $OUT_FILE"
  echo -e "\tRun:             $RUN_FLAG"
  echo
}

#------------------------------------------------------------------------------
Commits()
{
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
      echo -e "* [\`\`\`$hash\`\`\`](${COMMIT_URL}/$hash) $msg";

      # Increment commit counter
      i=`expr $i + 1`
    done;
}

Release()
{

  #------------------------------------
  # Release Header
  echo "## ${NEW_VER_NAME}"
  echo
  #------------------------------------
  # Notes Header

  target_notes=${NOTES_DIR}/Notes_${NEW_VER_NAME}.md

  if [[ -f $target_notes ]]; then
    echo "### Notes"
    echo
    grep -r '[0-9]\. ' $target_notes
    echo
  fi

  #------------------------------------
  # Pull Requests Header

  # Retieve PR hashes
  arr_pr_commits=( `git ls-remote origin 'pull/*/head' | awk '{print substr($1,1,7)}' | tr '\n' ' ' ` )
  pr_id=( `git ls-remote origin 'pull/*/head' | cut -f 2 | cut -d "/" -f 3 | tr '\n' ' ' ` )
  num_pr=${#arr_pr_commits[@]}

  # Retrieve commit hashes
  arr_new_ver_commits=($(Commits ${OLD_VER} ${NEW_VER} | cut -d '`' -f 4 | tr '\n' ' '))

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

  #------------------------------------
  # Commits Header
  echo "### Commits"
  echo
  Commits ${OLD_VER} ${NEW_VER} ${MAX_COMMITS}
  echo

}

#------------------------------------------------------------------------------
Changelog()
{
  # Move old changelog
  mkdir -p ${NOTES_DIR}
  new_ver_log=${NOTES_DIR}/"CHANGELOG_${NEW_VER_NAME}.md"

  if [[ -f CHANGELOG.md ]]; then
      echo "CHANGELOG.md will be moved to ${new_ver_log}"
      mv CHANGELOG.md ${new_ver_log}
  fi

  #------------------------------------
  # Changelog Header
  echo -e "# CHANGELOG\n" > CHANGELOG.md  

  #------------------------------------
  # Write updates
  prev_tag=${ARR_TAGS[0]}
  for ((i=1; i<${NUM_TAGS}; i++));
  do
    # Parse the current tag
    cur_tag=${ARR_TAGS[$i]}
    echo "Comparing $prev_tag to $cur_tag"
    # Create release notes for the current tag
    Release ${cur_tag} ${prev_tag} $MAX_COMMITS $NOTES_DIR >> CHANGELOG.md
    prev_tag=$cur_tag
    i+=1
  done  
}

#------------------------------------------------------------------------------
# Credits: https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
PARAMS=""
while (( "$#" )); do
  case "$1" in

    # Help
    -h|--help)
      Help
      exit 1
      ;; 

    # Version
    -v|--version)
      Version
      exit 1
      ;;  

    # Old version
    --old-ver)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        OLD_VER=$2
        shift
      else
        shift
      fi
      ;;  

    # New version
    --new-ver)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        NEW_VER=$2
        shift
      else
        shift
      fi
      ;;  

    # Max commits
    --max-commits)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MAX_COMMITS=$2
        shift
      else
        shift
      fi
      ;;  

    # Notes Directory
    --notes-dir)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        NOTES_DIR=$2
        shift
      else
        shift
      fi
      ;;        

    # Commit History
    --commits)
      RUN_FLAG="Commits"
      shift
      ;;   

    # Release Notes
    --release)
      RUN_FLAG="Release"
      shift
      ;;        

    # Release Notes
    --changelog)
      RUN_FLAG="Changelog"
      shift
      ;;          

    # Unsupported Flags             
    -*|--*=)
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    # Position Parameters
    *)
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

#------------------------------------------------------------------------------
# Name of the new version
if [[ $NEW_VER == "HEAD" ]]; then
  NEW_VER_NAME="Development"
else
  NEW_VER_NAME="$NEW_VER"
fi

$RUN_FLAG $OLD_VER $NEW_VER $MAX_COMMITS $NOTES_DIR