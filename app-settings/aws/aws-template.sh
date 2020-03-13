#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "${bold}ERROR:${normal} Check that you are properly sourcing the script"
    echo
    echo "This script should be run as:"
    echo "$ ${bold}source${normal} ./aws-fartbagxp.sh"
    exit 1
fi

echo "Switching AWS environment!"
export AWS_PROFILE=default
export AWS_ACCESS_KEY_ID=123456
export AWS_SECRET_ACCESS_KEY=123456
export AWS_DEFAULT_REGION=us-east-1

rm -rf ~/.aws/credentials

aws configure set aws_access_key_id 123456
aws configure set aws_secret_access_key 123456
aws configure set default.region us-east-1
aws configure set default.output json
