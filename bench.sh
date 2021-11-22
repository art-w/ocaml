#!/bin/sh
export NB_RUNS=5
export BENCHMARK_FILE="$1"
echo benchmark file is "$BENCHMARK_FILE"

timings () {
  project=$1
  grep '^[0-9]\+\.[0-9]\+s ' build.log \
    | sed 's/^\([0-9]\+.[0-9]\+\)s .*$$/\1/g' \
    | awk "1{s+=\$1} END{print \"projects\\t$project\\t\" s}" \
    >> "$BENCHMARK_FILE"
}

dune_build () {
  project=$1
  cd "$project"
  for i in $(seq 1 "$NB_RUNS"); do
    rm -f build.log
    dune clean
    OCAMLPARAM=",_,timings=1" dune build --verbose . 2>&1 | tee -a build.log
    cat build.log | timings "$project"
  done
  cd ..
}

bootstrap () {
  for i in $(seq 1 "$NB_RUNS"); do
    rm -f build.log
    make clean
	  OCAMLPARAM=",_,timings=1" make world.opt | tee -a build.log
    cat build.log | timings 'ocaml'
  done
}

eval $(opam env)

opam switch create . --empty
opam pin -ny .

./configure --prefix=$(opam var prefix)

bootstrap

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
echo '--- DUNE WILL BE INSTALLED ---'
echo
opam install dune
eval $(opam env)
ocaml --version

opam switch list

cd ..

cd dune
for i in $(seq 1 "$NB_RUNS"); do
  rm -f build.log
  make clean
  OCAMLPARAM=",_,timings=1" make release 2>&1 | tee -a build.log
  cat build.log | timings "dune"
done
cd ..

cd opam
opam install crowbar
opam install -y -t --deps-only .
./configure
for i in $(seq 1 "$NB_RUNS"); do
  rm -f build.log
  make clean
  OCAMLPARAM=",_,timings=1" make 2>&1 | tee -a build.log
  cat build.log | timings "opam"
done
cd ..

dune_build deque
dune_build mirage

opam_build() {
  project=$1
  cd "$project"
  opam pin -ny .
  opam install -y -t --deps-only .
  cd ..
  dune_build "$project"
}

opam_build ocaml-containers

opam_build decompress

opam_build menhir

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
# cat build.log | timings "zarith"
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
# cat build.log | timings "coq"
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
