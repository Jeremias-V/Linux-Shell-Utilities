#!/bin/bash
# Compiling C++11 and comparing output for https://onlinejudge.org/
# For this shell script to work properly, place this file inside a directory
# in which there is only 4 files; verify.sh, (filename).cpp, input.txt, compare.txt
# To make this file executable, either use 'bash verify.sh' or 'chmod +x verify.sh' and then run the file './verify.sh'
# Coded by Jeremias Villalobos Tenorio.

RED='\e[1;31m'
GREEN='\e[1;32m'
WHITE='\e[0m'
CYAN='\e[1;36m'

echo -e "\nFor this script to work properly, make sure you fulfill the following conditions:\n\n\
\033[1m1)\033[0m This file (${CYAN}verify.sh${WHITE}) should be placed inside a directory.\n\
\033[1m2)\033[0m In the same directory you sould only have 4 files:\n   ${CYAN}verify.sh${WHITE}, ${CYAN}file.cpp${WHITE}, ${CYAN}input.txt${WHITE} and ${CYAN}compare.txt${WHITE}.\n\
\033[1m3)\033[0m ${CYAN}file.cpp${WHITE} should be the source code you are going to compile in C++11.\n\
\033[1m4)\033[0m ${CYAN}input.txt${WHITE} should be the input for you program to run.\n\
\033[1m5)\033[0m ${CYAN}compare.txt${WHITE} should be the expected correct output to compare your program.\n"
echo "Do you fulfill the conditions above? (y/n) "
read run

if [ $run != "y" ]
    then
    exit 0
fi

nfiles=$(ls *.cpp | wc -l)

if [ $nfiles != 1 ]
    then
    echo -e "${RED}Error: found $nfiles source code files.${WHITE}"
    exit 0
fi

if [ ! -e "input.txt" ]
    then
    echo -e "${RED}Error: 'input.txt' not found.${WHITE}"
    exit 0
fi

if [ ! -e "compare.txt" ]
    then
    echo -e "${RED}Error: 'compare.txt' ${RED}not found.${WHITE}"
    exit 0
fi

if [ -e "a.out" ]; then rm a.out; fi

g++ -lm -lcrypt -O2 -std=c++11 -pipe -DONLINE_JUDGE *.cpp

if [ ! -e "a.out" ]
    then
    echo -e "${RED}Error: could not compile '$(ls *.cpp)' or the compiled file 'a.out' is not found.${WHITE}"
    exit 0
fi

./a.out < input.txt > output.txt
differ=$(diff -a -C 1 output.txt compare.txt)

if [ $? -eq 0 ]
    then
    echo -e "\n${GREEN}Success! ${WHITE}Your code compiled and the output is as expected.\n"
else
    echo -e "\n${RED}Error: ${WHITE}Your code compiled but the output is not as expected.\nThe following differences were found."
    sleep 1.5
    echo -e "\n${differ}\n"
fi

rm a.out output.txt

exit 0