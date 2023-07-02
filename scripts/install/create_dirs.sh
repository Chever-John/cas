#!/usr/bin/env bash

# shellcheck disable=SC2164
cd "$CAS_ROOT"
source scripts/install/environment.sh
sudo mkdir -p "${CAS_DATA_DIR}"/chever-apiserver
sudo mkdir -p "${CAS_INSTALL_DIR}"/bin
sudo mkdir -p "${CAS_CONFIG_DIR}"/cert
sudo mkdir -p "${CAS_LOG_DIR}"