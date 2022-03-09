#!/bin/sh
export NB_RUNS=2
export BENCHMARK_FILE="$1"
HERE=$(realpath "$(dirname "$0")")
export HERE

binaries() {
  project=$1
  find . -type f \
    | grep -ve '\.git' -ve '_opam' \
    | xargs -n1 file -i \
    | grep 'binary$' \
    | cut -f1 -d: \
    | xargs -n1 du -s \
    | awk "1{s+=\$1} END{print \"binaries\\t$project\\t\" s \"\tkb\"}" \
  >> "$BENCHMARK_FILE"
}

timings () {
  project=$1
  grep '^\s\s[0-9]\+\.[0-9]\+s ' build.log \
    | grep -v 'other$' \
    | awk "{sum[\$2] += \$1} END{for (i in sum) print \"projects\\t$project/\" i \"\\t\" sum[i] \"\tsecs\"}" \
    >> "$BENCHMARK_FILE"
  binaries "$project"
  LC_NUMERIC=POSIX awk -f "${HERE}/testsuite/tests/benchmarks/to_json.awk" < "$BENCHMARK_FILE"
  rm "$BENCHMARK_FILE"
}

dune_build () {
  project=$1
  version=$2
  target=${3:-.}
  cd "$project"
  if [ ! -z $version ]; then
      git checkout $version
  fi
  for i in $(seq 1 "$NB_RUNS"); do
    rm -f build.log
    dune clean
    echo
    echo
    echo "@@@@@@@@@@@ dune build $project $target"
    echo
    echo
    OCAMLPARAM=",_,timings=1" dune build --verbose --profile=release "$target" 2>&1 | tee -a build.log | sed 's/^{/ {/'
    timings "$project"
  done
  cd ..
}

opam_build() {
  project=$1
  version=$2
  target=${3:-.}
  cd "$project"
  if [ ! -z $version ]; then
      git checkout $version
  fi
  opam pin -ny .
  opam install -y -t --deps-only .
  cd ..
  dune_build "$project" "$version" "$target"
}

bootstrap () {
  for i in $(seq 1 "$NB_RUNS"); do
    rm -f build.log
    make clean
    OCAMLPARAM=",_,timings=1" make world.opt | tee -a build.log | sed 's/^{/ {/'
    timings 'ocaml'
  done
}

eval $(opam env)

opam switch create . --empty
opam pin -ny .

./configure --prefix=$(opam var prefix)
make world.opt | sed 's/^{/ {/'
echo
echo '--- OCAML WILL BE INSTALLED ---'
echo
opam install --assume-built --debug -y .

echo
echo '--- OCAML DEPENDENCIES WILL BE INSTALLED ---'
echo
opam install base-unix base-bigarray base-threads
eval $(opam env)

echo
echo '--- IS OCAML OKAY? ---'
echo

ocaml --version

opam switch list

echo
echo '--- IS OCAML OKAY? AND NOW? ---'
echo

eval $(opam env --switch=. --set-switch)

ocaml --version

opam switch list

echo
echo '--- OCAML BOOTSRAP ---'
echo

bootstrap

ocaml --version

echo
echo '--- DUNE WILL BE INSTALLED ---'
echo
opam update
eval $(opam env)
ocaml --version
opam install -y dune
eval $(opam env)
ocaml --version

opam switch list

cd ..

cd dune
for i in $(seq 1 "$NB_RUNS"); do
  rm -f build.log
  make clean
  OCAMLPARAM=",_,timings=1" make release 2>&1 | tee -a build.log | sed 's/^{/ {/'
  timings "dune"
done
cd ..


opam install -y num
eval $(opam env)
opam install -y ppxlib.0.24.0
eval $(opam env)
opam install -y sexplib
eval $(opam env)
opam install -y git-unix git-paf
eval $(opam env)


opam_build ocamlgraph bd6c8ce2e64dee10e800aeda648684409cfa0bff

opam_build irmin "2.9.0"

cd opam
opam install crowbar
opam install -y -t --deps-only .
./configure
for i in $(seq 1 "$NB_RUNS"); do
  rm -f build.log
  make clean
  OCAMLPARAM=",_,timings=1" make 2>&1 | tee -a build.log | sed 's/^{/ {/'
  timings "opam"
done
cd ..

dune_build deque 20d3cfafa93b73c9f7ee20c230dc3e1b3f86956e

opam_build ocaml-containers 40189757cae1de9e43bf9c7ac92d7412868b2846

opam_build decompress 1871eea4d5a1e72116b4202c05a07bfb57965ad9

opam_build menhir 7fdc5a97d2baa8ced49e07879e1841f1b13b4132 '--only-packages=menhir'

# dune_build mirage

# cd zarith
# echo 'opam install conf-gmp'
# opam install --debug -y conf-gmp
# echo 'opam install ocamlfind'
# opam install --debug -y ocamlfind
#
# echo
# echo
#
# opam show ocaml
#
# echo
# echo
#
# echo 'opam config set version'
# opam config set sys-ocaml-version 4.14.0
# echo 'opam config set-global version'
# opam config set-global sys-ocaml-version 4.14.0
#
# opam show ocaml
#
# echo
# echo
#
#
# opam pin --debug -ny .
# echo 'pin zarith okay!'
# echo
# rm -f build.log
# ./configure
# OCAMLPARAM=",_,timings=1" make 2>&1 | tee -a build.log
# timings "zarith"
# echo 'opam config set version'
# opam config set sys-ocaml-version 4.14.0
# echo 'opam config set-global version'
# opam config set-global sys-ocaml-version 4.14.0
# echo 'ok now?'
# echo
# eval $(opam env)
# opam install --debug -y --assume-built zarith.1.12 ./zarith.opam
# cd ..

### Issue with zarith
# opam install -y lablgtk3-sourceview3
# export CAML_LD_LIBRARY_PATH="$(realpath ocaml/_opam/lib/stublibs):$CAML_LD_LIBRARY_PATH"
# cd coq
# rm -f build.log
# opam pin -ny .
# OCAMLPARAM=",_,timings=1" dune build --verbose --profile=release . 2>&1 | tee -a build.log
# timings "coq"
# cd ..



# opam_build owl # errors with non-erasable optional arguments
# dune_build js-monorepo # requires ppxlib

### !!! Can't actually install lwt, as it depends on ppxlib which requires caml<4.14 !!!
### echo
### echo '--- LWT WILL BE INSTALLED ---'
### echo
###
### cd lwt
### opam install -y result ppxlib react luv
### opam pin -n .
### opam install -y -t --deps-only .
### eval $(opam env)
### cd ..
### dune_build lwt
### cd lwt
### opam install --assume-built --debug -y .
### cd ..
###
### echo
### echo '--- LWT INSTALLED ---'
### echo

### !!! Irmin also depends on lwt !!!
### cd irmin
### opam install -y logs
### opam install -y -t --deps-only .
### eval $(opam env)
### cd ..
### dune_build irmin
