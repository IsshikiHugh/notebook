#! /bin/bash

# get current direction
curDir=`pwd`
# get shell direction
workDir=$(cd "$(dirname "$0")";pwd)

cd $workDir

mkdocs gh-deploy
git add -A

if [ $# -gt 0 ]
then
    git commit -m "[Addition] $@"
else
    git commit -m "[Default] Content Synchronization"
fi

git push

cd $curDir
