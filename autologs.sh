#!/bin/bash

#------------------------------------------------------------------------------
# Help  

# Credits: https://opensource.com/article/19/12/help-bash-program
Help()
{
   # Display Help
   echo "Automatically create commit history, release notes, and a changelog."
   echo
   echo "Syntax: autologs [-h|v]"
   echo
   echo "Options:"
   echo -e "\t-h     Print this Help."
   echo -e "\t-v     Print software version and exit."
   echo
}


# Credits: https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
PARAMS=""
while (( "$#" )); do
  case "$1" in
    -a|--my-boolean-flag)
      MY_FLAG=0
      shift
      ;;
    -h|--help)
      HELP_FLAG=1
      Help
      exit 1
      ;;      
    -b|--my-flag-with-argument)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MY_FLAG_ARG=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
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