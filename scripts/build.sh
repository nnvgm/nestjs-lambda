#!/bin/bash

# rm -rf node_modules
# yarn
# yarn build
# yarn install --production
zip -r nestjs-lambda.zip dist
zip -r nestjs-lambda.zip node_modules
zip -j nestjs-lambda.zip scripts/run.sh
zip nestjs-lambda.zip package.json
