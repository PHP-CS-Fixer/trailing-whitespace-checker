#!/bin/bash

run_test() {
    echo -ne "Running test \\e[33m\"$(echo "$1" | sed -E "s/.*\\/(.*)\\//\\1/")\"\\e[0m... "

    expected_status_code="$(perl -p -e 'BEGIN{undef $/;} s/^--STATUS-CODE--\n(\d+)\n.*$/$1/s' "${1}test")"
    expected_output="$(echo -e "$(perl -p -e 'BEGIN{undef $/;} s/^.*--OUTPUT--\n(.*)\n$/$1/s' "${1}test")")"

    cd "${1}files" || return 3
    output=$(../../../check-trailing-whitespaces)
    status_code="$?"
    cd "$OLDPWD" || return 3

    if [ "${status_code}" != "${expected_status_code}" ]
    then
        echo -e "\\e[31mFailing asserting that status code ${status_code} matches expected status code ${expected_status_code}:\\e[0m"

        return 3
    fi

    if [ "${output}" != "${expected_output}" ]
    then
        echo -e "\\e[31mFailing asserting that output matches expected output:\\e[0m"
        diff -u <(echo "${expected_output}" ) <(echo "${output}")

        return 3
    fi

    echo -e "\\e[32mOK\\e[0m"

    return 0
}

# setup
# Git does not allow to track a .git directory so we copy .svn
rm -rf tests/default_ignored_paths/files/.git tests/default_ignored_paths/files/directory/.git
cp -r tests/default_ignored_paths/files/.svn tests/default_ignored_paths/files/.git
cp -r tests/default_ignored_paths/files/directory/.svn tests/default_ignored_paths/files/directory/.git

# run tests
i=0
failures=0
for test_case in "$(dirname "$(realpath "$0")")"/*/
do
    if [ "$i" -gt 0 ]
    then
        echo
    fi


    if ! run_test "${test_case}"
    then
        ((++failures))
    fi

    ((++i))
done

# clean
rm -rf tests/default_ignored_paths/files/.git tests/default_ignored_paths/files/directory/.git

# exit
if [ "${failures}" -ne 0 ]
then
    exit 3
fi

exit 0
