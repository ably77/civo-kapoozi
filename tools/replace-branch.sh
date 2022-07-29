# tested on macos
#!/bin/bash
current_branch=''$1''
target_branch=''$2''

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

#platform-owners/mgmt
sed -i '' -e 's/'${current_branch}'/'${target_branch}'/g' ../platform-owners/mgmt/mgmt-apps.yaml
sed -i '' -e 's/'${current_branch}'/'${target_branch}'/g' ../platform-owners/mgmt/mgmt-cluster-config.yaml
sed -i '' -e 's/'${current_branch}'/'${target_branch}'/g' ../platform-owners/mgmt/mgmt-infra.yaml
sed -i '' -e 's/'${current_branch}'/'${target_branch}'/g' ../platform-owners/mgmt/mgmt-mesh-config.yaml