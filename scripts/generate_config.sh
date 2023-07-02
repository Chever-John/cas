#!/usr/bin/env bash

# 本脚本功能：根据 scripts/environment.sh 配置，生成 IAM 组件 YAML 配置文件。
# 命令执行示例：generate_config.sh scripts/environment.sh configs/iam-apiserver.yaml

env_file="$1"
template_file="$2"

CAS_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

source "${CAS_ROOT}/scripts/lib/init.sh"

if [ $# -ne 2 ];then
    cas::log::error "Usage: generate_config.sh scripts/environment.sh configs/cas-apiserver.yaml"
    exit 1
fi

# shellcheck disable=SC1090
source "${env_file}"

# shellcheck disable=SC2034
declare -A envs

set +u
# shellcheck disable=SC2013
for env in $(sed -n 's/^[^#].*${\(.*\)}.*/\1/p' "${template_file}")
do
    if [ -z "$(eval echo \$"${env}")" ];then
        cas::log::error "environment variable '${env}' not set"
        missing=true
    fi
done

if [ "${missing}" ];then
    # shellcheck disable=SC2016
    cas::log::error 'You may run `source scripts/environment.sh` to set these environment'
    exit 1
fi

eval "cat << EOF
$(cat "${template_file}")
EOF"
