.PHONY : all
all : build

.PHONY : build
build :
	@ dune build --display=short
	@ dune install rocq-please

.PHONY : install
install :
	@ dune install

.PHONY : doc
doc :
	@ dune build @theories/doc

.PHONY : clean
clean :
	@ dune clean
