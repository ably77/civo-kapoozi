# tested on macos
#!/bin/bash
current_username=''$1''
target_username=''$2''
# number of app waves in the environments directory
environment_waves="$(ls ../environment | wc -l)"

# check to see if github username variable was passed through, if not prompt for it
if [[ ${current_username} == "" ]]
  then
    # provide github username
    echo "Please provide the Github username used to fork this repo:"
    read current_username
fi

# check to see if target username variable was passed through, if not prompt for it
if [[ ${target_username} == "" ]]
  then
    # provide github username
    echo "Please provide the GitHub username you want to use:"
    read target_username
fi

# sed commands to replace target_username variable
for i in $(seq ${environment_waves}); do 
  sed -i '' -e 's/'${current_username}'/'${target_username}'/g' ../environment/wave-${i}/wave-${i}-aoa.yaml; 
done