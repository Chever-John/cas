#!/usr/bin/env bash

set -o errexit
set +o nounset
set -o pipefail

unset CDPATH

# Default use go modules
export GO111MODULE=on

# The root of the build/dist directory
CAS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"

source "${CAS_ROOT}/scripts/lib/util.sh"
source "${CAS_ROOT}/scripts/lib/logging.sh"
source "${CAS_ROOT}/scripts/lib/color.sh"

cas::log::install_errexit

source "${CAS_ROOT}/scripts/lib/version.sh"
source "${CAS_ROOT}/scripts/lib/golang.sh"
