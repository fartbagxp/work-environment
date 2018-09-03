#!/usr/bin/env bash

echo "Switching to templated AWS environment!"
export AWS_PROFILE=<should match ~/.aws/config>
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=us-east-1
