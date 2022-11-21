#! /bin/bash

# get current direction
curDir=`pwd`
# get shell direction
workDir=$(cd "$(dirname "$0")";pwd)

cd $workDir

git add -A

if [ $# -gt 0 ]
then
    git commit -m "[+] $@"
else
    git commit -m "[Default] Content Synchronization"
fi

git push

cd $curDir
