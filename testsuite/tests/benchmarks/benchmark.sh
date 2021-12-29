#!/bin/sh

test -z "${BENCHMARK_FILE}" && exit ${TEST_SKIP}

dir=$(basename "${test_source_directory}")
pattern=${1-'.*'}
ctx=${2-''}
if [ ! -z "${ctx}" ]; then ctx=$ctx'.'; fi
file="${ctx}${test_file}"

( test -f "${compiler_output}"  && cat "${compiler_output}" ;
  test -f "${compiler_output2}" && cat "${compiler_output2}"
) | awk '{if (match($0,"ocamlopt.opt")) exit; print}' \
  | grep '^\s\s[0-9]\+\.[0-9]\+s ' \
  | awk "{sum[\$2] += \$1} END{for (i in sum) print \"${dir}\\t${file}/\" i \"\\t\" sum[i] \"\tsecs\"}" \
        >> "${BENCHMARK_FILE}"
