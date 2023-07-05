#!/usr/bin/env bash

CAS_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

source "${CAS_ROOT}/scripts/common.sh"

readonly LOCAL_OUTPUT_CONFIGPATH="${LOCAL_OUTPUT_ROOT}/configs"
mkdir -p ${LOCAL_OUTPUT_CONFIGPATH}

cd ${CAS_ROOT}/scripts

export CAS_APISERVER_INSECURE_BIND_ADDRESS=0.0.0.0
export CAS_AUTHZ_SERVER_INSECURE_BIND_ADDRESS=0.0.0.0

# 集群内通过kubernetes服务名访问
export CAS_APISERVER_HOST=cas-apiserver
export CAS_AUTHZ_SERVER_HOST=cas-authz-server
export CAS_PUMP_HOST=cas-pump
export CAS_WATCHER_HOST=cas-watcher

# 配置CA证书路径
export CONFIG_USER_CLIENT_CERTIFICATE=/etc/cas/cert/admin.pem
export CONFIG_USER_CLIENT_KEY=/etc/cas/cert/admin-key.pem
export CONFIG_SERVER_CERTIFICATE_AUTHORITY=/etc/cas/cert/ca.pem

for comp in cas-apiserver
do
  cas::log::info "generate ${LOCAL_OUTPUT_CONFIGPATH}/${comp}.yaml"
  ./generate_config.sh install/environment.sh ../configs/${comp}.yaml > ${LOCAL_OUTPUT_CONFIGPATH}/${comp}.yaml
done

