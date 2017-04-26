#! /bin/sh
# Copyright (c) 2011-2015 by Vertica, an HP Company.  All rights reserved.
# Automates installation of AWS CLI

set -o errtrace
set -o pipefail
set -o errexit

. ./autoscaling_vars.sh

echo Install and configure AWS CLI

if [[ -f ~/.aws/config || -f ~/.aws/credentials ]]; then echo "not overwriting ~/.aws/config" ; exit 255; fi

TEMP_AWSCLI=./tmp-awscli

mkdir -p ${TEMP_AWSCLI}

sh -c "(
curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o ${TEMP_AWSCLI}/awscli-bundle.zip
cd ${TEMP_AWSCLI} && unzip -o ./awscli-bundle.zip && cd -
sudo -E ${TEMP_AWSCLI}/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
)" || rm -rf ${TEMP_AWSCLI}

mkdir -p ~/.aws
cat > ~/.aws/credentials <<EOF
[default]
aws_access_key_id = $aws_access_key_id
aws_secret_access_key = $aws_secret_access_key
EOF
cat > ~/.aws/config <<EOF
[default]
output = table
region = $region
EOF

echo AWS CLI installed

rm -rf ${TEMP_AWSCLI}
