#!/bin/bash
min_ver="0.24.0"
max_ver="0.24.10"
check_ver="0.21.4"
if [ "$( echo -e "${min_ver}\\n${max_ver}\\n${check_ver}" | sort --sort=version | head -2 | tail -1)" == ${check_ver} ]
then
    echo "${check_ver} is between the above two versions"
else
    echo "${check_ver} is not in between these two versions"
fi