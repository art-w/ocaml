#!/bin/sh
export NB_RUNS=5
export BENCHMARK_FILE="$1"

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

opam install --assume-built --debug -y ./ocaml.opam

opam install base-unix base-bigarray base-threads
eval $(opam env)

ocaml --version

opam switch list

eval $(opam env --switch=. --set-switch)

ocaml --version

opam switch list

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
