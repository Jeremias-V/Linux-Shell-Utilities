#!/bin/bash

## Compiling C++11 and comparing output for testing code before submiting https://onlinejudge.org/
## For this shell script to work properly, place this file inside an empty directory when running for the first time.
## To make this file executable, either use 'bash verify.sh' or 'chmod +x verify.sh' and then run the file './verify.sh'
## Coded by Jeremias Villalobos Tenorio.

# Defining formatting variables.

RED='\e[1;31m'
GREEN='\e[1;32m'
WHITE='\e[0m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
BOLD='\033[1m'
PLAIN='\033[0m'

# Check if it's first run.

if [ ! -e ".runVerifysh" ]
    then
    nfiles=$(ls | wc -l)
    if [ $nfiles -gt 1 ]; 
        then 
        echo -e "\n${RED}Error:${WHITE} Directory should be empty for the first run. Found $((${nfiles} - 1)) additional file(s).\n"
        exit 1
    else
        touch .runVerifysh input.txt expectedOutput.txt
        echo -e "\nFiles ${CYAN}input.txt${WHITE} and ${CYAN}expectedOutput.txt${WHITE} were created.\n"
        sleep 2
    fi
fi

# Defining main function called verify

verify () {

    # Check if there is only one source code file.

    nfiles=$(ls *.cpp 2> /dev/null | wc -l)

    if [ $nfiles != 1 ]
        then
        echo -e "\n${RED}Error:${WHITE} Found $nfiles source code files.\n"
        exit 1
    fi

    # Check if files exist and are not empty.

    if [ ! -e "input.txt" ]
        then
        echo -e "\n${RED}Error:${WHITE} ${CYAN}'input.txt${WHITE} not found.\n"
        exit 1
    else
        if [ ! -s "input.txt" ]
        then
        echo -e "\n${RED}Error:${WHITE} ${CYAN}input.txt${WHITE} is empty.${WHITE}\n"
        exit 1
        fi
    fi

    if [ ! -e "expectedOutput.txt" ]
        then
        echo -e "\n${RED}Error: ${CYAN}expectedOutput.txt${WHITE} ${RED}not found.${WHITE}\n"
        exit 1
    else
        if [ ! -s "expectedOutput.txt" ]
        then
        echo -e "\n${RED}Error:${WHITE} ${CYAN}expectedOutput.txt${WHITE} is empty.${WHITE}\n"
        exit 1
        fi
    fi

    # Compiling and checking if compiled successfully

    g++ -lm -lcrypt -O2 -std=c++11 -pipe -DONLINE_JUDGE *.cpp 2> /dev/null

    if [ $? -eq 1 ]
        then
        echo -e "\n${RED}Error:${WHITE} Could not compile ${CYAN}$(ls *.cpp)${WHITE}.\n"
        exit 1
    fi

    # Running program with input and saving output

    timeout 3 ./a.out < input.txt > output.txt

    # Checking if program takes too long to run.

    if [ $? -eq 124 ]
        then
        echo -e "\n${RED}Error:${WHITE} Time limit exceeded. Output file deleted.${WHITE}\n"
        rm output.txt
        exit 1
    fi

    # Checking if the program ran successfully

    if [ $? -eq 1 ]
        then
        echo -e "\n${RED}Error:${WHITE} Something went wrong while executing ${CYAN}$(ls *.cpp)${WHITE}.\n"
        exit 1
    fi

    # Comparing expected output and real output

    if [ -e "diff.txt" ]; then rm diff.txt; fi
    differ=$(diff -a -C 1 output.txt expectedOutput.txt)

    if [ $? -eq 0 ]
        then
        echo -e "\n${GREEN}Success! ${WHITE}Your code compiled and the output is as expected.\n"
    else
        diffSize=$(echo -e "${differ}" | wc -l)
        if [ $diffSize -gt 24 ]
            then
            echo -e "\n${RED}Error:${WHITE}\tYour code compiled but the output is not as expected."
            echo -e "\n${YELLOW}Warning:${WHITE} Too many differences found.\nSaving file ${CYAN}diff.txt${WHITE} so that you can review it.\nNow displaying 10 lines (first 5 and last 5) of ${CYAN}diff.txt${WHITE}:\n"
            echo -e "Your Output\t\t\t\t\tExpected Output" > diff.txt | diff -y -W105 output.txt expectedOutput.txt >> diff.txt
            cat diff.txt | head -6
            cat diff.txt | tail -5
            echo
        else
            echo -e "\n${RED}Error:${WHITE}\tYour code compiled but the output is not as expected.\n\tThe following differences were found."
            echo -e "\n${differ}\n"
        fi
    fi

    rm output.txt

}

# Check conditions to run.

if [ "$1" != "-y" ]
    then
    echo -e "\nFor this script to work properly, make sure you fulfill the following\nconditions:\n\
    \n${BOLD}1)${PLAIN} This file (${CYAN}verify.sh${WHITE}) should be placed inside a directory.\n\
    \n${BOLD}2)${PLAIN} In the same directory you sould only have 4 files (${CYAN}a.out${WHITE} doesn't count):\n   ${CYAN}verify.sh${WHITE}, ${CYAN}*.cpp${WHITE}, ${CYAN}input.txt${WHITE} and ${CYAN}expectedOuput.txt${WHITE}.\n\
    \n${BOLD}3)${PLAIN} ${CYAN}*.cpp${WHITE} ('*' implies any filename but with '.cpp' extension) should be the\n   source code you are going to compile in C++11.\n\
    \n${BOLD}4)${PLAIN} ${CYAN}input.txt${WHITE} should be the input file for you program to read from\n   (i.e. '*.cpp < input.txt').\n\
    \n${BOLD}5)${PLAIN} ${CYAN}expectedOutput.txt${WHITE} should be the expected correct output to compare\n   your program.\n\
    \n${BOLD}6)${PLAIN} ${CYAN}input.txt${WHITE} and ${CYAN}expectedOutput.txt${WHITE} should not be empty.\n\
    \n${BOLD}If you don't want to display this confirmation again, just run 'verify.sh -y'\n(run with the '-y' argument).${PLAIN}\n"
    echo -e "Do you fulfill the conditions above? (${BOLD}y${PLAIN}/${BOLD}n${PLAIN}) "
    read run

    case $run in

        "n" | "N")
        exit 0
        ;;
        "y" | "Y")
        verify
        exit 0
        ;;
        *)
        echo -e "\n${RED}Error:${WHITE} '${run}' is not a valid option.\n"
        exit 1
        ;;

    esac

else
    verify
    exit 0
    
fi