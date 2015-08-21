escape_string() {
    echo "$1" | sed 's#[]\/$*.^|[]#\\&#g'
}


assert_success() {
    if [ "$status" -eq 0 ]; then
        return 0
    fi
    echo "Exit status is: $status but expecting 0"
    echo "Output:"
    echo "$output"
    return 1
}


assert_fail() {
    if [ "$status" -ne 0 ]; then
        return 0
    fi
    echo "Exit status is: $status but expecting not 0"
    echo "Output:"
    echo "$output"
    return 1
}


assert_output_contains() {
    STRING_1=$(escape_string "$1")
    if [ $(echo "$output" | grep -c -e "$STRING_1") -ne 0 ]; then
        return 0
    fi
    echo "Output:"
    echo "$output"
    return 1
}


assert_output_not_contains() {
    STRING_1=$(escape_string "$1")
    if [ $(echo "$output" | grep -c -e "$STRING_1") -eq 0 ]; then
        return 0
    fi
    echo "Output:"
    echo "$output"
    return 1
}


assert_output_empty() {
    if [ "$output" == "" ]; then
        return 0
    fi
    echo "Output:"
    echo "$output"
    return 1
}


get_in_array() {
    if [ $1 -lt 0 ]; then
        length=${#lines[@]}
        position=$((length + $1))
        echo -n "${lines[$position]}"
    else
        echo -n "${lines[$1]}"
    fi
    return 0
}


assert_line_contains() {
    STRING_2=$(escape_string "$2")
    if [ $(echo "$(get_in_array $1)" | grep -c -e "$STRING_2") -eq 1 ]; then
        return 0
    fi
    echo "Line $1:"
    echo "$(get_in_array $1)"
    return 1
}


assert_line_not_contains() {
    STRING_2=$(escape_string "$2")
    if [ $(echo "$(get_in_array $1)" | grep -c -e "$STRING_2") -eq 0 ]; then
        return 0
    fi
    echo "Line $1:"
    echo "$(get_in_array $1)"
    return 1
}


assert_line_equals() {
    if [ "$(get_in_array $1)" == "$2" ]; then
        return 0
    fi
    echo "Line $1:"
    echo "$(get_in_array $1)"
    return 1
}


# Insert '| cat' at the end to prevent bats to catch last command error
assert_output_contains_in_table() {
    result="${output}"
    for string in "$@"; do
        escaped_string=$(escape_string "${string}")
        result=$(echo "$result" | grep -e "| *$escaped_string *|" | cat)
    done
    if [ "${result}" != "" ]; then
        return 0
    fi
    echo "Output:"
    echo "$output"
    return 1
}


assert_output_not_contains_in_table() {
    result="${output}"
    for string in "$@"; do
        escaped_string=$(escape_string "${string}")
        result=$(echo "$result" | grep -e "| *$escaped_string *|" | cat)
    done
    if [ "${result}" == "" ]; then
        return 0
    fi
    echo "Output:"
    echo "$output"
    return 1
}
