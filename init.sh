#!/bin/bash
#

PS4='+ $(date +"%F %T%z") ${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

set -ue


os="$(uname|tr A-Z a-z)"
os="${os/darwin/macos}"
dir="$(cd $(dirname $0) && pwd)"
tmp="$(mktemp).sh"
shell="${SHELL##*bin/}"


cat ${dir}/${os}/init.${os}.sh    > ${tmp}
cat ${dir}/common/init.common.sh >> ${tmp}

echo -e "Run: \n\tbash ${tmp}\n"

