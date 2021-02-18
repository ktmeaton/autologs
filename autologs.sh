#!/bin/bash

VERSION=0.1.0

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

Help()
{
  # Display Help
  # Credits: https://opensource.com/article/19/12/help-bash-program
  # Display Help
  echo "Automatically create commit history, release notes, and a changelog."
  echo
  echo "Syntax: autologs [-h|v] OLD_VER NEW_VER MAX_COMMITS NOTES_DIR"
  echo
  echo "Options:"
  echo -e "\t-h, --help        Print this Help."
  echo -e "\t-v, --version     Print software version and exit."
  echo
  echo -e "\tOLD_VER           An earlier version to compare to (tag or commit hash)."
  echo -e "\tNEW_VER           An earlier version to compare to (tag or commit hash)."  
  echo -e "\tMAX_COMMITS       The maximum number of commits to print."
  echo
}

Version()
{
  # Display Version
  echo "$VERSION"
}

Commits()
{
  # Retrieve the autologs directory
  autologs_dir=`AbsPath`;
  # Execute the commit history script
  ${autologs_dir}/"scripts/commits.sh"
}



# Credits: https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
PARAMS=""
while (( "$#" )); do
  case "$1" in
    -h|--help)
      Help
      exit 1
      ;; 
    -v|--version)
      Version
      exit 1
      ;;   
    -c|--commits)
      Commits
      exit 1
      ;;                
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

if [[ $HELP_FLAG ]]; then
    echo printing HELP
fi
echo $PARAMS