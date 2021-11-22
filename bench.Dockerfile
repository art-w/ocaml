FROM ocaml/opam:debian-10-ocaml-4.12

RUN sudo apt-get update && sudo apt-get install -qq -yy libffi-dev \
        liblmdb-dev m4 pkg-config gnuplot-x11 libgmp-dev libssl-dev \
        libpcre3-dev curl build-essential \
        liblapacke-dev libopenblas-dev libplplot-dev libshp-dev \
        zlib1g-dev libgtksourceview-3.0-dev

RUN opam remote add origin https://opam.ocaml.org \
    && opam repository set-url default https://github.com/ocaml/opam-repository.git \
    && opam repository add dune-universe git+https://github.com/dune-universe/opam-overlays.git \
    && opam install -y dune opam-monorepo \
    && eval $(opam env)

RUN git clone 'https://github.com/mirage/mirage/' \
    && cd mirage && opam monorepo lock && opam monorepo pull && cd ..

RUN git clone 'https://github.com/art-w/deque/'

RUN git clone 'https://github.com/ocaml/dune'

RUN git clone 'https://github.com/c-cube/ocaml-containers'

RUN git clone 'https://gitlab.inria.fr/fpottier/menhir.git'

RUN git clone 'https://github.com/ocaml/zarith'

RUN git clone 'https://github.com/mirage/decompress'

RUN git clone 'https://github.com/ocaml/opam'

RUN git clone 'https://github.com/coq/coq'

# RUN git clone 'https://github.com/owlbarn/owl.git'

# RUN git clone 'https://github.com/mirage/irmin'

# RUN git clone 'https://github.com/ocsigen/lwt'

# RUN git clone 'https://github.com/emillon/js-monorepo' \
#     && cd js-monorepo && opam monorepo pull && cd ..

COPY --chown=opam:opam . ocaml

WORKDIR ocaml
