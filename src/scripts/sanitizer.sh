#!/bin/sh
# Sanitizer script - keep sources clean and tidy
# see https://portal.tpt.com/infopoint/display/CAT/Sanitizer
#
# This script is preconfigured for Bamboo

# Bamboo variables used:
# bamboo.planRepository.1.repositoryUrl -> ${bamboo_planRepository_1_repositoryUrl}
# bamboo.repository.branch.name -> ${bamboo_repository_branch_name}
# bamboo.MVN -> ${bamboo_MVN}
# bamboo.OPSVIEWER_PASSWORD -> ${bamboo_OPSVIEWER_PASSWORD}

echo
echo "[SANITIZER] Start me up"
echo

# get branch name from Bamboo
BRANCH=${bamboo_repository_branch_name}
# get git repository URL
REPO="$(echo ${bamboo_planRepository_1_repositoryUrl} | cut -d "/" -f4,5)"
REPO="https://opsviewer:${bamboo_OPSVIEWER_PASSWORD}@portal.tpt.com/stash/scm/${REPO}"

# -------------------------------------------
# display current platform info
# -------------------------------------------
echo "[SANITIZER] Name of repository:     ${REPO}"
echo "[SANITIZER] Name of branch:         ${BRANCH}"
# get branch name, from current git repository
BRANCH2="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
if [ "$BRANCH" != "$BRANCH2" ]; then
  echo "[SANITIZER] Branch name from Bitbucket variable and actual branch are not equal, exiting."
  exit 1
fi

echo
echo "[SANITIZER] Capturing initial state of environment"
${bamboo_MVN} enforcer:display-info -T1
git --version
git config --list --show-origin
echo

# -------------------------------------------
# cleanup and prepare git branch
# -------------------------------------------
echo
echo "[SANITIZER] Cleanup and preparation"
git clean -xdf
if git show-ref --quiet temp; then
  echo "[SANITIZER] Deleting 'temp' branch if exists"
  git branch -d temp
fi
git pull
git remote rm temp
git remote add temp ${REPO}
echo "[SANITIZER] Just ignore 'fatal: No such remote: temp'"

# -------------------------------------------
# license header task
# -------------------------------------------
echo
echo "[SANITIZER] License header task started"
if ${bamboo_MVN} license:check \
    -Dlicense.quiet=true \
    -Dlicense-maven-plugin.skip=false \
    -Denforcer.java.version.range=0 \
    -T1 ; then
  echo "[SANITIZER] License headers were OK"
else
  echo "[SANITIZER] Updating license headers"
  ${bamboo_MVN} license:remove license:remove license:format \
    -Dlicense.quiet=true \
    -Dlicense-maven-plugin.skip=false \
    -Denforcer.java.version.range=0 \
    -T1 ;
  git add .
  git status
  git commit -m "Sanitizer - License headers updated"
fi

# -------------------------------------------
# line normalization task
# -------------------------------------------
echo
echo "[SANITIZER] Line normalization task started"
git rm --cached -r .
git config core.autocrlf input
git diff --cached --name-only -z | xargs -0 git add
git status
git commit -F- <<EOF
Sanitizer - Line endings normalized

- replaced CRLF with LF
EOF

# -------------------------------------------
# sortpom task
# -------------------------------------------
echo
echo "[SANITIZER] Sortpom task started"
${bamboo_MVN} com.github.ekryd.sortpom:sortpom-maven-plugin:sort \
  -Dcheckstyle.skip=true \
  -Denforcer.java.version.range=0 \
  -Dsort.skip=false \
  -Dsort.createBackupFile=false \
  -Dsort.expandEmptyElements=false \
  -Dsort.ignoreLineSeparators="true" \
  -Dsort.keepBlankLines=false \
  -Dsort.nrOfIndentSpace=0 \
  -Dsort.sortProperties=true \
  -Dsort.predefinedSortOrder="recommended_2008_06" \
  -T1 -e
${bamboo_MVN} tidy:pom \
  -Dsort.skip=true \
  -T1 -e
${bamboo_MVN} com.github.ekryd.sortpom:sortpom-maven-plugin:sort \
  -Dcheckstyle.skip=true \
  -Denforcer.java.version.range=0 \
  -Dsort.skip=false \
  -Dsort.createBackupFile=false \
  -Dsort.expandEmptyElements=false \
  -Dsort.ignoreLineSeparators="true" \
  -Dsort.keepBlankLines=true \
  -Dsort.nrOfIndentSpace=2 \
  -Dsort.sortProperties=true \
  -Dsort.predefinedSortOrder="recommended_2008_06" \
  -T1 -e
git add .
git status
git commit -F- <<EOF
Sanitizer - Sortpom

- pom.xml(s) sorted
EOF

# -------------------------------------------
# tabs to spaces task
# -------------------------------------------
echo
echo "[SANITIZER] Tabs to spaces task started"
RND=$(cat /dev/urandom| tr -dc '0-9a-z'|head -c 2);
find . -name '*.java' ! -type d -exec bash -c 'expand -t 2 "$0" > /tmp/'${RND}' && mv /tmp/'${RND}' "$0"' {} \;
git add .
git status
git commit -F- <<EOF
Sanitizer - Converted tabs to spaces

- applies only to .java files
EOF

# -------------------------------------------
# code format task
# -------------------------------------------
echo
echo "[SANITIZER] Code format task started"
if ${bamboo_MVN} com.coveo:fmt-maven-plugin:check -T1 ; then
  echo "[SANITIZER] Code already formatted"
else
  echo "[SANITIZER] Formatting code"
  ${bamboo_MVN} com.coveo:fmt-maven-plugin:format -T1 ;
  git add .
  git status
  git commit -F- <<EOF
Sanitizer - Code formatted

- applying 'Google Java Style'
EOF
  echo "[SANITIZER] Code formatted"
fi

# -------------------------------------------
# finalization tasks
# -------------------------------------------
echo
echo "[SANITIZER] finalization tasks started"
# do a test compile
${bamboo_MVN} clean test -Pinsane
STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo "[SANITIZER] Test compile successful"
else
  echo "[SANITIZER] Something went wrong, exiting"
  exit 1
fi
# avoid merge commit and fail on conflict
if git pull --rebase; then
  echo "[SANITIZER] Pull before push successful"
else
  echo "[SANITIZER] Oooops, exiting"
  exit 1
fi
#push changes to remote
if git push temp ${BRANCH}; then
  echo "[SANITIZER] Changes, if any, pushed to git repository"
else
  echo "[SANITIZER] Nevermind, exiting"
  exit 1
fi

echo
echo "[SANITIZER] This is the end"
echo
