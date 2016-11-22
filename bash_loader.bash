#!/bin/bash

# get the folder where it does execute from
BASH_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -f $BASH_FOLDER/variables.bash ]; then
    . $BASH_FOLDER/variables.bash
fi
if [ -f $BASH_FOLDER/bash_aliases.bash ]; then
    . $BASH_FOLDER/bash_aliases.bash
fi
if [ -f $BASH_FOLDER/git_utility.bash ]; then
    . $BASH_FOLDER/git_utility.bash
fi
if [ -f $BASH_FOLDER/ps1.bash ]; then
    . $BASH_FOLDER/ps1.bash
fi
