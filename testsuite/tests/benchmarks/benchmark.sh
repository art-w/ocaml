#!/bin/sh

test -z "${BENCHMARK_FILE}" && exit ${TEST_SKIP}

dir=$(basename "${test_source_directory}")
pattern=${1-'.*'}
ctx=${2-''}
if [ ! -z "${ctx}" ]; then ctx=$ctx'.'; fi
file="${ctx}${test_file}"

( test -f "${compiler_output}"  && cat "${compiler_output}" ;
  test -f "${compiler_output2}" && cat "${compiler_output2}"
) | sed -n "/^ *0*\([0-9]\+.[0-9]\+\)s ${pattern}$/{s//\1/p;q}" \
  | ( read elapsed ; echo "${dir}\t${file}\t${elapsed}\tsecs" ) \
  >> "${BENCHMARK_FILE}"
