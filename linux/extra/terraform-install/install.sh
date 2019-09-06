#!/usr/bin/env bash

version=0.12.8
wget https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip
unzip terraform_${version}_linux_amd64.zip
sudo mv terraform /usr/local/bin/

