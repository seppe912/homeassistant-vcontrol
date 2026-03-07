#!/usr/bin/env bash

fail() {
    printf 'FAIL: %s\n' "$*" >&2
    exit 1
}

assert_eq() {
    local expected=$1
    local actual=$2
    local message=${3:-"values differ"}

    if [[ "${expected}" != "${actual}" ]]; then
        fail "${message}: expected <${expected}> got <${actual}>"
    fi
}

assert_file_exists() {
    local path=$1

    [[ -f "${path}" ]] || fail "expected file to exist: ${path}"
}

assert_file_contains() {
    local path=$1
    local pattern=$2

    grep -Fq -- "${pattern}" "${path}" || fail "expected ${path} to contain: ${pattern}"
}
