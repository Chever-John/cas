#!/usr/bin/env bash

# shellcheck disable=SC2034 # Variables sourced in other scripts.

# The server platform we are building on.
readonly CAS_SUPPORTED_SERVER_PLATFORMS=(
  linux/amd64
  linux/arm64
)

# If we update this we should also update the set of platforms whose standard
# library is precompiled for in build/build-image/cross/Dockerfile
readonly CAS_SUPPORTED_CLIENT_PLATFORMS=(
  linux/amd64
  linux/arm64
)

# The set of server targets that we are only building for Linux
# If you update this list, please also update build/BUILD.
cas::golang::server_targets() {
  local targets=(
    cas-apiserver
  )
  echo "${targets[@]}"
}

IFS=" " read -ra CAS_SERVER_TARGETS <<< "$(cas::golang::server_targets)"
readonly CAS_SERVER_TARGETS
readonly CAS_SERVER_BINARIES=("${CAS_SERVER_TARGETS[@]##*/}")

# The set of server targets we build docker images for
cas::golang::server_image_targets() {
  # NOTE: this contains cmd targets for cas::build::get_docker_wrapped_binaries
  local targets=(
    cmd/cas-apiserver
  )
  echo "${targets[@]}"
}

IFS=" " read -ra CAS_SERVER_IMAGE_TARGETS <<< "$(cas::golang::server_image_targets)"
readonly CAS_SERVER_IMAGE_TARGETS
readonly CAS_SERVER_IMAGE_BINARIES=("${CAS_SERVER_IMAGE_TARGETS[@]##*/}")

# ------------
# NOTE: All functions that return lists should use newlines.
# bash functions can't return arrays, and spaces are tricky, so newline
# separators are the preferred pattern.
# To transform a string of newline-separated items to an array, use cas::util::read-array:
# cas::util::read-array FOO < <(cas::golang::dups a b c a)
#
# ALWAYS remember to quote your subshells. Not doing so will break in
# bash 4.3, and potentially cause other issues.
# ------------

# Returns a sorted newline-separated list containing only duplicated items.
cas::golang::dups() {
  # We use printf to insert newlines, which are required by sort.
  printf "%s\n" "$@" | sort | uniq -d
}

# Returns a sorted newline-separated list with duplicated items removed.
cas::golang::dedup() {
  # We use printf to insert newlines, which are required by sort.
  printf "%s\n" "$@" | sort -u
}

# Depends on values of user-facing CAS_BUILD_PLATFORMS, CAS_FASTBUILD,
# and CAS_BUILDER_OS.
# Configures CAS_SERVER_PLATFORMS and CAS_CLIENT_PLATFORMS, then sets them
# to readonly.
# The configured vars will only contain platforms allowed by the
# CAS_SUPPORTED* vars at the top of this file.
declare -a CAS_SERVER_PLATFORMS
declare -a CAS_CLIENT_PLATFORMS
cas::golang::setup_platforms() {
  if [[ -n "${CAS_BUILD_PLATFORMS:-}" ]]; then
    # CAS_BUILD_PLATFORMS needs to be read into an array before the next
    # step, or quoting treats it all as one element.
    local -a platforms
    IFS=" " read -ra platforms <<< "${CAS_BUILD_PLATFORMS}"

    # Deduplicate to ensure the intersection trick with cas::golang::dups
    # is not defeated by duplicates in user input.
    cas::util::read-array platforms < <(cas::golang::dedup "${platforms[@]}")

    # Use cas::golang::dups to restrict the builds to the platforms in
    # CAS_SUPPORTED_*_PLATFORMS. Items should only appear at most once in each
    # set, so if they appear twice after the merge they are in the intersection.
    cas::util::read-array CAS_SERVER_PLATFORMS < <(cas::golang::dups \
        "${platforms[@]}" \
        "${CAS_SUPPORTED_SERVER_PLATFORMS[@]}" \
      )
    readonly CAS_SERVER_PLATFORMS

    cas::util::read-array CAS_CLIENT_PLATFORMS < <(cas::golang::dups \
        "${platforms[@]}" \
        "${CAS_SUPPORTED_CLIENT_PLATFORMS[@]}" \
      )
    readonly CAS_CLIENT_PLATFORMS

  elif [[ "${CAS_FASTBUILD:-}" == "true" ]]; then
    CAS_SERVER_PLATFORMS=(linux/amd64)
    readonly CAS_SERVER_PLATFORMS
    CAS_CLIENT_PLATFORMS=(linux/amd64)
    readonly CAS_CLIENT_PLATFORMS
  else
    CAS_SERVER_PLATFORMS=("${CAS_SUPPORTED_SERVER_PLATFORMS[@]}")
    readonly CAS_SERVER_PLATFORMS

    CAS_CLIENT_PLATFORMS=("${CAS_SUPPORTED_CLIENT_PLATFORMS[@]}")
    readonly CAS_CLIENT_PLATFORMS
  fi
}

cas::golang::setup_platforms

# The set of client targets that we are building for all platforms
# If you update this list, please also update build/BUILD.
readonly CAS_CLIENT_TARGETS=(
  casctl
)
readonly CAS_CLIENT_BINARIES=("${CAS_CLIENT_TARGETS[@]##*/}")

readonly CAS_ALL_TARGETS=(
  "${CAS_SERVER_TARGETS[@]}"
  "${CAS_CLIENT_TARGETS[@]}"
)
readonly CAS_ALL_BINARIES=("${CAS_ALL_TARGETS[@]##*/}")

# Asks golang what it thinks the host platform is. The go tool chain does some
# slightly different things when the target platform matches the host platform.
cas::golang::host_platform() {
  echo "$(go env GOHOSTOS)/$(go env GOHOSTARCH)"
}

# Ensure the go tool exists and is a viable version.
cas::golang::verify_go_version() {
  if [[ -z "$(command -v go)" ]]; then
    cas::log::usage_from_stdin <<EOF
Can't find 'go' in PATH, please fix and retry.
See http://golang.org/doc/install for installation instructions.
EOF
    return 2
  fi

  local go_version
  IFS=" " read -ra go_version <<< "$(go version)"
  local minimum_go_version
  minimum_go_version=go1.13.4
  if [[ "${minimum_go_version}" != $(echo -e "${minimum_go_version}\n${go_version[2]}" | sort -s -t. -k 1,1 -k 2,2n -k 3,3n | head -n1) && "${go_version[2]}" != "devel" ]]; then
    cas::log::usage_from_stdin <<EOF
Detected go version: ${go_version[*]}.
CAS requires ${minimum_go_version} or greater.
Please install ${minimum_go_version} or later.
EOF
    return 2
  fi
}

# cas::golang::setup_env will check that the `go` commands is available in
# ${PATH}. It will also check that the Go version is good enough for the
# CAS build.
#
# Outputs:
#   env-var GOBIN is unset (we want binaries in a predictable place)
#   env-var GO15VENDOREXPERIMENT=1
#   env-var GO111MODULE=on
cas::golang::setup_env() {
  cas::golang::verify_go_version

  # Unset GOBIN in case it already exists in the current session.
  unset GOBIN

  # This seems to matter to some tools
  export GO15VENDOREXPERIMENT=1

  # Open go module feature
  export GO111MODULE=on

  # This is for sanity.  Without it, user umasks leak through into release
  # artifacts.
  umask 0022
}
