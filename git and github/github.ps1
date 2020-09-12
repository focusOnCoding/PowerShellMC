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

# merge to the main branch
git merge testing

# clone a project donw from git 
# Download from [URL]
git clone https://github.com/focusOnCoding/learninggit2/import

# see the origin
git remote show 

# see the location in memory
git remote show origin 

# this will conect my local repository to the remote one 
# this will add this repository to my work space if it does not allready exises
git remote add origin https://github.com/focusOnCoding/leaninggitt.git

# see there is a git gub connection
git remote show

# now i can see more infore with the 
git remote show origin

# push a file from my locale enviroment to a remote one in github
# push this folder to the master
git push -u origin master

# get all the breanches
git breanch -a

# if i want to checkout someones changes in my code i can use
git checkout -b nameOfTheBranch master

# the i can pull | download it down to my local enviroment
git pull https://github.com/...../....../ thatPersonsCodeFileName

# download letest features
git pull

# add . and commit at the same time in one line
git commit -a -m "this wont let me pick it commits everything"

# rewrite the message 
git commit --amend -m "Now i can rewrite the masseg here"

# take branch and Join() it with master | main
git rebase main

# use the -i for interactive 
git rebase -i main # will pause at the begining of the file let me pick what happens next