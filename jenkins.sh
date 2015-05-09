#!/usr/bin/env bash
GIT_BRANCH=$1
BUILD_NUMBER=$2
echo "Building app for branch: ${GIT_BRANCH}";
agvtool new-version -all "${BUILD_NUMBER}"
echo "Changed version to ${BUILD_NUMBER}"

if [ "${GIT_BRANCH}" = "origin/develop" ]; then
ipa build --clean -w Faces.xcworkspace -s Faces --archive --configuration Debug  && ipa distribute:crashlytics -c Faces/Crashlytics.framework -a df45d086fdfbfa0fc287e23c9ad0a5dfb9a2182f -s 5be33800276e506e984992430e90dc58c707833f2e113e59d332a7429f5dbd18 --groups devs
else 
ipa build --clean -w Faces.xcworkspace -s Faces --archive  --configuration Release && ipa distribute:itunesconnect -a bartosz+de@hernas.pl -p Tata1234 -i 990021487 --upload
fi

