#! /bin/bash

# get current direction
curDir=`pwd`
# get shell direction
workDir=$(cd "$(dirname "$0")";pwd)

# Get files.
srcDir=$workDir/../docs
cd $srcDir
tree -f > $workDir/file_list

cd $workDir
# Start renders
sed -i '' 's/│/ /g' file_list
sed -i '' 's/├── /  - /g' file_list
sed -i '' 's/└── /  - /g' file_list
sed -i '' 's/    /  /g' file_list
sed -i '' 's/\.\///g' file_list
sed -i '' '1d' file_list

cd $curDir
