#!/bin/bash

# Function: replace_contents
# $1: Path to the answer file

function replace_contents {
  answer_file="$1"
  result_file="$(dirname "${answer_file}")/../cases/$(basename "${answer_file}" .answer).result"
  
  if [ -f "${result_file}" ]; then
    # 결과 파일이 존재하면 내용을 읽어와 answer 파일로 복사
    cp "${result_file}" "${answer_file}"
    echo "Replaced contents in ${answer_file} with ${result_file}"
  else
    echo "Result file ${result_file} not found for ${answer_file}"
  fi
}

# Function: process_directory
# $1: Directory path
# $2: grep -q condition string
function process_directory {
  directory="$1"
  grep_condition="$2"
  
  # Process answer files within the directory
  for answer_file in "${directory}"/answers/*.answer; do
    if [ -f "${answer_file}" ]; then
      # Check the grep -q condition string
      if grep -q "${grep_condition}" "${answer_file}"; then
        replace_contents "${answer_file}"
      fi
    fi
  done
  
  # Recursively process subdirectories
  for sub_directory in "${directory}"/*/; do
    if [ -d "${sub_directory}" ]; then
      process_directory "${sub_directory}" "${grep_condition}"
    fi
  done
}

# Main script start
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <root_directory> <grep_condition>"
  exit 1
fi

root_directory=$(realpath "$1")
grep_condition="$2"

# process from root_directory
process_directory "${root_directory}" "${grep_condition}"
