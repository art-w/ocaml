(* TEST
script = "sh ${test_source_directory}/../benchmark.sh typing"
flags = "-dtimings"
* setup-ocamlc.byte-build-env
** ocamlc.byte
*** script
*)

module type A = sig
  module type A = sig
    module type A = sig
      module type A = sig
        module type A = sig
          module type A = sig
            module type A = sig
              module type A = sig
                module type A = sig
                  module type A = sig
                    module type A = sig
                      module type A = sig
                        module type A = sig
                          module type A = sig
                            include Map.S
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
