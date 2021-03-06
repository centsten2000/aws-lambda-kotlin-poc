#!/bin/bash -e

PROFILE=default
LAMBDA_NAME="kotlin-lambda-poc"
HANDLER="com.floodfx.kotlin.lambda.App::handleRequest"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_DIR=$SCRIPT_DIR/../../scripts
ZIP_PATH="$SCRIPT_DIR/../build/distributions/$LAMBDA_NAME.zip"

STAGE=$1
if [ -z "$STAGE" ]; then
  STAGE='dev'
fi

cd $SCRIPT_DIR/..
gradle build

aws lambda update-function-configuration \
  --function $LAMBDA_NAME-$STAGE \
  --handler $HANDLER \
  --environment "Variables={STAGE=$STAGE}" \
  --profile $PROFILE

$SCRIPT_DIR/update-lambda.sh $LAMBDA_NAME $ZIP_PATH $STAGE
