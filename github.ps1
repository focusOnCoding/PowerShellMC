# get the version
git --version

# git init create a git repo in a folder
git init

# create the user 
git config --global user.name UserNameGoesHere

# user email
git config --global user.email EmailGoesHere

# change dir
cd .. 

# use this file
touch index.html

# see more inforemation about my work 
get status  # see my changes 

# stage for a file to be add 
git add . # now i can commit

# add file to be seen by git
git add test.txt # now git will start looking at this file

# commit the files 
git commit -m "this is my test commit"

# restore files
git restore test.txt 

# see who edited the files
git log

# time trave
git checkout [ID]#of the state to go back in time to that state

# to switch back to main
git checkout main

# a better way to checkout is not just to checkout the past but to create a space or branch where i can test out new fetures 
git checkout -b testing # this will switch me to a new branch  