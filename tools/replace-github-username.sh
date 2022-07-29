# tested on macos
#!/bin/bash
github_username=''$1''

# check to see if license key variable was passed through, if not prompt for key
if [[ ${github_username} == "" ]]
  then
    # provide license key
    echo "Please provide the Github username used to fork this repo:"
    read github_username
fi

# sed commands to replace github_username variable

#platform-owners/cluster1
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster1/cluster1-apps.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster1/cluster1-cluster-config.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster1/cluster1-infra.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster1/cluster1-mesh-config.yaml

#platform-owners/cluster2
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster2/cluster2-apps.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster2/cluster2-cluster-config.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster2/cluster2-infra.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster2/cluster2-mesh-config.yaml

#platform-owners/cluster3
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster3/cluster3-apps.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster3/cluster3-cluster-config.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster3/cluster3-infra.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/cluster3/cluster3-mesh-config.yaml

#platform-owners/mgmt
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/mgmt/mgmt-apps.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/mgmt/mgmt-cluster-config.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/mgmt/mgmt-infra.yaml
sed -i '' -e 's/ably77/'${github_username}'/g' ../platform-owners/mgmt/mgmt-mesh-config.yaml