#!/bin/sh
for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

    case "$KEY" in
            HELP)               HELP=${VALUE} ;;
            ALIAS)              ALIAS=${VALUE} ;;
            FUNCTION)           FUNCTION=${VALUE} ;;     
            PREVIOUS_VERSION)   PREVIOUS_VERSION=${VALUE} ;;
            *)   
    esac    


done

if [ "$HELP" != "" ]; then
  echo "FUNCTION=my-lambda ALIAS=my-alias ./set-previous-to-full-traffic.sh"
  echo "or"
  echo "FUNCTION=my-lambda ALIAS=my-alias PREVIOUS_VERSION=1 ./set-previous-to-full-traffic.sh"
  exit 0
else
  true
fi

if [ -z "${PREVIOUS_VERSION}" ];
then
    echo "PREVIOUS_VERSION not provided, getting it by using ./get-latest-version.sh"
    PREVIOUS_VERSION=$(FUNCTION=$FUNCTION ./get-latest-version.sh)
fi

echo "rolling back by setting traffic on previous version of function: ${FUNCTION} and alias: ${ALIAS} to 100%"

aws lambda update-alias --name $ALIAS --function-name $FUNCTION --function-version $PREVIOUS_VERSION --routing-config AdditionalVersionWeights={}
