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
RUN_FLAG="Commits"
OUT_FILE="/dev/stdout"

#------------------------------------------------------------------------------
# Functions

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

Version()
{
  # Display Version
  echo "$VERSION"
}

Commits()
{
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
}

Release()
{
  # Execute the release notes script
  ${AUTOLOGS_DIR}/"scripts/release.sh"
}

Changelog()
{
  # Execute the changelog script
  ${AUTOLOGS_DIR}/"scripts/changelog.sh"
}


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

echo
echo "Creating Auto $RUN_FLAG with the following parameters."
echo -e "\tOld version:     $OLD_VER"
echo -e "\tNew version:     $NEW_VER"
echo -e "\tMax Commits:     $MAX_COMMITS"
echo -e "\tNotes Directory: $NOTES_DIR"
echo -e "\tOutput File:     $OUT_FILE"
echo -e "\tRun:             $RUN_FLAG"
echo

$RUN_FLAG $OLD_VER $NEW_VER $MAX_COMMITS $NOTES_DIR