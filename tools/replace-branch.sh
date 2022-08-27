# tested on macos
#!/bin/bash
current_branch=''$1''
target_branch=''$2''
# number of app waves in the environments directory
environment_waves="$(ls ../environment | wc -l)"

# check to see if current branch variable was passed through, if not prompt for it
if [[ ${current_branch} == "" ]]
  then
    # provide github branch
    echo "Please provide the current targeted Github branch:"
    read current_branch
fi

# check to see if target branch variable was passed through, if not prompt for it
if [[ ${target_branch} == "" ]]
  then
    # provide github branch
    echo "Please provide the GitHub branch you want to use:"
    read target_branch
fi

# sed commands to replace target_branch variable
for i in $(seq ${environment_waves}); do 
  sed -i '' -e 's/'${current_branch}'/'${target_branch}'/g' ../environment/wave-${i}/wave-${i}-aoa.yaml; 
done