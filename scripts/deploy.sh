#!/bin/bash

echo -e "\033[0;32mDeploying updates to Github...\033[0m"

# Build the project.
hugo -t hyde-hyde

echo -e "\033[0;32mAdd public folder contents...\033[0m"
# Go To Public folder
cd public
# Add changes to git.
git add -A

echo -e "\033[0;32mCommit changes to public folder...\033[0m"
# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

echo -e "\033[0;32mPush changes to public folder to Github...\033[0m"
# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..