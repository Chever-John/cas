#!/usr/bin/env bash

# Controls verbosity of the script output and logging.
CAS_VERBOSE="${CAS_VERBOSE:-5}"

# Handler for when we exit automatically on an error.
cas::log::errexit() {
  # ${PIPESTATUS[@]} is an array of exit status values from the processes in the most-recently-executed foreground
  # pipeline (which may contain only a single command).
  # put the exit status of each command into an array called PIPESTATUS, and then store it in a variable called err.
  local err="${PIPESTATUS[*]}"

  # If the shell we are in doesn't have errexit set (common in subshells) then
  # don't dump stacks.
  # check if errexit is set.
  # `set +o` is used to list all shell options.
  # `grep -qe "-o errexit"` is used to check if errexit is set.
  # if errexit is set, return 0, otherwise return non-zero value.

  # `||` is used to execute the `return` command if the previous command returns non-zero value.

  # Inclusion, if errexit is set, return 0, otherwise return non-zero value.
  set +o | grep -qe "-o errexit" || return

  # `set +o xtrace` is used to turn off the trace mode.
  # xtrace is used to print the command before executing it.
  set +o xtrace

  # `local code="${1:-1}"` is used to set the default value of code to 1 if the first argument is not provided.
  local code="${1:-1}"

  # Print out the stack trace described by $function_stack
  # Check the call stack size. if the size is greater than 2, print the call tree.
  # And that means current function is called by another function.
  if [ ${#FUNCNAME[@]} -gt 2 ]
  then
    cas::log::error "Call tree:"
    for ((i=1;i<${#FUNCNAME[@]}-1;i++))
    do
      cas::log::error " ${i}: ${BASH_SOURCE[${i}+1]}:${BASH_LINENO[${i}]} ${FUNCNAME[${i}]}(...)"
    done
  fi
  cas::log::error_exit "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status ${err}" "${1:-1}" 1
}

cas::log::install_errexit() {
  # trap ERR to provide an error handler whenever a command exits nonzero  this
  # is a more verbose version of set -o errexit
  trap 'cas::log::errexit' ERR

  # setting errtrace allows our ERR trap handler to be propagated to functions,
  # expansions and subshells
  set -o errtrace
}

# Print out the stack trace
#
# Args:
#   $1 The number of stack frames to skip when printing.
cas::log::stack() {
  local stack_skip=${1:-0}
  stack_skip=$((stack_skip + 1))
  if [[ ${#FUNCNAME[@]} -gt ${stack_skip} ]]; then
    echo "Call stack:" >&2
    local i
    for ((i=1 ; i <= ${#FUNCNAME[@]} - stack_skip ; i++))
    do
      local frame_no=$((i - 1 + stack_skip))
      local source_file=${BASH_SOURCE[${frame_no}]}
      local source_lineno=${BASH_LINENO[$((frame_no - 1))]}
      local funcname=${FUNCNAME[${frame_no}]}
      echo "  ${i}: ${source_file}:${source_lineno} ${funcname}(...)" >&2
    done
  fi
}

# Log an error and exit.
# Args:
#   $1 Message to log with the error
#   $2 The error code to return
#   $3 The number of stack frames to skip when printing.
cas::log::error_exit() {
  local message="${1:-}"
  local code="${2:-1}"
  local stack_skip="${3:-0}"
  stack_skip=$((stack_skip + 1))

  if [[ ${CAS_VERBOSE} -ge 4 ]]; then
    local source_file=${BASH_SOURCE[${stack_skip}]}
    local source_line=${BASH_LINENO[$((stack_skip - 1))]}
    echo "!!! Error in ${source_file}:${source_line}" >&2
    [[ -z ${1-} ]] || {
      echo "  ${1}" >&2
    }

    cas::log::stack ${stack_skip}

    echo "Exiting with status ${code}" >&2
  fi

  exit "${code}"
}

# Log an error but keep going.  Don't dump the stack or exit.
cas::log::error() {
  timestamp=$(date +"[%m%d %H:%M:%S]")
  echo "!!! ${timestamp} ${1-}" >&2
  shift
  for message; do
    echo "    ${message}" >&2
  done
}

# Print an usage message to stderr.  The arguments are printed directly.
cas::log::usage() {
  echo >&2
  local message
  for message; do
    echo "${message}" >&2
  done
  echo >&2
}

cas::log::usage_from_stdin() {
  local messages=()
  while read -r line; do
    messages+=("${line}")
  done

  cas::log::usage "${messages[@]}"
}

# Print out some info that isn't a top level status line
cas::log::info() {
  local V="${V:-0}"
  if [[ ${CAS_VERBOSE} < ${V} ]]; then
    return
  fi

  for message; do
    echo "${message}"
  done
}

# Just like cas::log::info, but no \n, so you can make a progress bar
cas::log::progress() {
  for message; do
    echo -e -n "${message}"
  done
}

cas::log::info_from_stdin() {
  local messages=()
  while read -r line; do
    messages+=("${line}")
  done

  cas::log::info "${messages[@]}"
}

# Print a status line.  Formatted to show up in a stream of output.
cas::log::status() {
  local V="${V:-0}"
  if [[ ${CAS_VERBOSE} < ${V} ]]; then
    return
  fi

  timestamp=$(date +"[%m%d %H:%M:%S]")
  echo "+++ ${timestamp} ${1}"
  shift
  for message; do
    echo "    ${message}"
  done
}
