#!/bin/sh
# Pullrequest sonar check script - keep sonar issues out of master
# https://portal.tpt.com/infopoint/display/CAT/Pull+request+Sonar+validation
#
# This script is preconfigured for Bamboo.
# Bitbucket pull request id must be entered manually. In Bamboo job, choose 'Run customized'
# and 'Override' BB_PULLREQUEST_ID with pull request id (number).

# Bamboo variables used:
# bamboo.planRepository.1.repositoryUrl -> ${bamboo_planRepository_1_repositoryUrl}
# bamboo.repository.branch.name -> ${bamboo_repository_branch_name}
# bamboo.BB_PULLREQUEST_ID -> ${bamboo_BB_PULLREQUEST_ID}
# bamboo.MVN -> ${bamboo_MVN}

echo
echo "[PULLREQUEST-SONAR-CHECK] Start me up"
echo

# branch name check. Fail job if on 'master' branch.
BRANCH=${bamboo_repository_branch_name}
if [ "$BRANCH" == 'master' ]; then
  echo "[PULLREQUEST-SONAR-CHECK] Current branch is 'master'. Pick different branch."
  exit 1
fi
BRANCH2="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
if [ "$BRANCH" != "$BRANCH2" ]; then
  echo "[PULLREQUEST-SONAR-CHECK] Branch name from Bitbucket variable and actual branch are not equal, exiting."
  exit 1
fi

# get Bitbucket project name and git repository name
BITBUCKET_PROJECT="$(echo ${bamboo_planRepository_1_repositoryUrl} | cut -d "/" -f4)"
BITBUCKET_REPOSITORY="$(echo ${bamboo_planRepository_1_repositoryUrl} | cut -d "/" -f5)"
BITBUCKET_REPOSITORY=${BITBUCKET_REPOSITORY/.git}

# run sonar analysis, fail job if anything goes wrong
echo "[PULLREQUEST-SONAR-CHECK] Start Sonar analysis on pull request # ${bamboo_BB_PULLREQUEST_ID}"
${bamboo_MVN} clean install -U -T1 -e
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo
else
  echo "[PULLREQUEST-SONAR-CHECK] 'mvn clean install' failed. Exiting."
  exit 1
fi

${bamboo_MVN} sonar:sonar \
  -Dsonar.analysis.mode=issues \
  -Dsonar.stash.notification=true \
  -Dsonar.stash.project=${BITBUCKET_PROJECT} \
  -Dsonar.stash.repository=${BITBUCKET_REPOSITORY} \
  -Dsonar.stash.pullrequest.id=${bamboo_BB_PULLREQUEST_ID} \
  -Dsonar.stash.comments.reset=true \
  -Dsonar.stash.include.overview=true \
  -T1 \
  -e
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo
else
  echo "[PULLREQUEST-SONAR-CHECK] 'mvn sonar:sonar' failed. Exiting."
  exit 1
fi

echo
echo "[PULLREQUEST-SONAR-CHECK] Done."
echo