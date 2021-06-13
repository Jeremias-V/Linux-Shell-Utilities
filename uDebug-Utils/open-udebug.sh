#!/bin/bash
# Simple tool to open uDebug page for the given UVa problem ID number.
# I will clean the code using functions later.

# Terminal Colors
RED='\e[1;31m'
GREEN='\e[1;32m'
WHITE='\e[0m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'

# File count variables
pyfiles=$(ls *.py 2>/dev/null | wc -l)
cppfiles=$(ls *.cpp 2>/dev/null | wc -l)
cfiles=$(ls *.c 2>/dev/null | wc -l)

if [ $pyfiles -eq 1 -a $cppfiles -eq 0 -a $cfiles -eq 0 ]

    # Only found 1 python file
    then 
    ID=$(ls *.py | awk '{i=index($1,"."); print substr($1,0,i-1)}')
    echo -e "\n${GREEN}Opening${WHITE} uDebug UVa ${CYAN}${ID}${WHITE} at https://www.udebug.com/UVa/$ID\n"
    xdg-open https://www.udebug.com/UVa/$ID
    exit 0

elif [ $pyfiles -eq 0 -a $cppfiles -eq 1 -a $cfiles -eq 0 ]

    # Only found 1 C++ file
    then
    ID=$(ls *.cpp | awk '{i=index($1,"."); print substr($1,0,i-1)}')
    echo -e "\n${GREEN}Opening${WHITE} uDebug UVa ${CYAN}${ID}${WHITE} at https://www.udebug.com/UVa/$ID\n"
    xdg-open https://www.udebug.com/UVa/$ID
    exit 0

elif [ $pyfiles -eq 0 -a $cppfiles -eq 0 -a $cfiles -eq 1 ]

    # Only found 1 Ansi C file
    then
    ID=$(ls *.c | awk '{i=index($1,"."); print substr($1,0,i-1)}')
    echo -e "\n${GREEN}Opening${WHITE} uDebug UVa ${CYAN}${ID}${WHITE} at https://www.udebug.com/UVa/$ID\n"
    xdg-open https://www.udebug.com/UVa/$ID
    exit 0

elif [ $pyfiles -eq 0 -a $cppfiles -eq 0 -a $cfiles -eq 0 ]

    # Didn't found any accepted file.
    then
    echo -e "\n${RED}Error:${WHITE} Couldn't find any file with a valid extension ${CYAN}*.{py, cpp, c}${WHITE}.\n"
    exit 1

else

    # Found multiple valid files.
    echo -e "\n${YELLOW}Warning:${WHITE} Multiple files with valid extensions (${CYAN}*.{py, cpp, c}${WHITE}) found."
    read -p "Enter the numeric problem ID -> " ID

    count=$(ls $ID.* 2> /dev/null | wc -l)

    if [ $count -ne 0 ]

        # Given ID is valid (i.e. in current working directory).
        then
        echo -e "\n${GREEN}Opening${WHITE} uDebug UVa ${CYAN}${ID}${WHITE} at https://www.udebug.com/UVa/$ID\n"
        xdg-open https://www.udebug.com/UVa/$ID
        exit 0

    else

        # Given ID is not in current directory.
        countValid=$(ls *.{py,cpp,c} 2>/dev/null | wc -l)

        if [ $countValid -eq 0 ]

            # No valid file exists
            then
            echo -e "\n${RED}Error:${WHITE} Couldn't find any valid file in current directory, move to your working directory.\n"
            exit 1

        else

            # Couldn't find the given ID but found multiple valid files.
            echo -e "\n${RED}Error:${WHITE} The given ID is not in the current directory, try the UVa ID of any of these files.${CYAN}"
            ls --color=none *.{py,cpp,c} 2>/dev/null
            echo -e "${WHITE}"
            exit 0

        fi

    fi

fi
