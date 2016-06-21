#!/bin/bash

CUR_BRANCH="$(git rev-parse --short HEAD)"

#indentation
L=$(for i ; do echo ${#i} ; done | sort -n | tail -n 1)
#color
RED='\033[0;31m'
YEL='\033[0;33m'
GRE='\033[0;32m'
NC='\033[0m'

for TRACK in ${*}
do
    if ! git rev-parse -q --verify ${TRACK} > /dev/null 2>&1
    then printf "%-${L}s : [${RED}not a brach${NC}] \n" "${TRACK}"
         continue
    fi
    BEHIND="$(git rev-list ${CUR_BRANCH}..${TRACK} --count)"
    AHEAD="$(git rev-list ${TRACK}..${CUR_BRANCH} --count)"
    A=$([ ${AHEAD} -eq 0 ]  || printf "${YEL}ahead:${AHEAD}${NC}" )
    B=$([ ${BEHIND} -eq 0 ] || printf "${RED}behind:${BEHIND}${NC}")
    MSG=$([ -z "${A}" -o -z "${B}" ] && printf "${A}${B}" || printf "${A}, ${B}")
    printf "%-${L}s : [${GRE}%s${NC}] \n" "${TRACK}" "${MSG:-OK}"
done
