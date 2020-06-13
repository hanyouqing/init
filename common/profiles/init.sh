#!/bin/bash
#

show() {
    for p in $(ls -ad $PWD/.* | grep -v '\.$'); do echo ${p} ~/; done
}

ln() {
    for p in $(ls -ad $PWD/.* | grep -v '\.$'); do echo "ln -s ${p} ~/$(basename ${p})"; done
}

cp() {
    for p in $(ls -ad $PWD/.* | grep -v '\.$'); do echo "cp -p ${p} ~/$(basename ${p})"; done
}

$1