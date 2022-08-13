# tested on macos
#!/bin/bash
github_username=''$1''
# number of app waves in the environments directory
environment_waves="4"

# check to see if github username variable was passed through, if not prompt for key
if [[ ${github_username} == "" ]]
  then
    # provide github username
    echo "Please provide the Github username used to fork this repo:"
    read github_username
fi

# sed commands to replace target_branch variable
for i in $(seq ${environment_waves}); do 
  sed -i '' -e 's/ably77/'${github_username}'/g' ../environment/wave-${i}/wave-${i}-aoa.yaml; 
done