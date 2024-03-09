#!/bin/bash

while [[ $# -gt 0 ]]; do
  case $1 in
  --version)
    version=$2
    shift
    ;;
  *)
    shift
    ;;
  esac
done

if [[ -z $version ]]; then
  version="latest"
fi

pushd source-code
rm -rf node_modules
rm -rf nestjs-lambda-$version.zip
yarn
yarn build
yarn install --production
zip -r nestjs-lambda-$version.zip dist
zip -r nestjs-lambda-$version.zip node_modules
zip -j nestjs-lambda-$version.zip run.sh
zip nestjs-lambda-$version.zip package.json

if [[ $version == "latest" ]]; then
  # delete before upload
  aws s3 rm s3://shared-source-code/nestjs-lambda/latest --recursive
fi

aws s3 cp nestjs-lambda-$version.zip s3://shared-source-code/nestjs-lambda/$version/nestjs-lambda-$version.zip
popd
