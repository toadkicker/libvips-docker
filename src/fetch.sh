#!/usr/bin/env bash

# Fetch RELEASEs from the repo
TMPL_PATH='../templates/Dockerfile.template'
LIBVIPS_RELEASES=$(curl -s https://api.github.com/repos/libvips/libvips/releases  | jq '.')
# for each RELEASE, create a dockerfile
for RELEASE in $LIBVIPS_RELEASES;
do
  echo 'Release: \n' + $RELEASE
  # create a directory for the version
  # for each asset in the $RELEASE
  DESCRIPTION="$($RELEASE|jq '.body' $1))"
  VERSION_TAG="$($RELEASE|jq '.tag_name' $1))"
  mkdir -p ../tags/$($VERSION_TAG)/
  for asset in $(jq -s '.assets[]' $RELEASE);
  do
    # create a new dockerfile from $TMPL_PATH
    file=$($asset|jq '.name' $1).dockerfile
    destination="../src/$($VERSION_TAG)/$($file)"
    cp $TMPL_PATH $destination
    cat $destination | envsubst < [$DESCRIPTION $VERSION_TAG]
  done

done
exit 0