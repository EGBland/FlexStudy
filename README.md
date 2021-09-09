# FlexStudy
Scanners and tokenisers written in "fast lexical analyser generator" (flex). Generate the scanners with `./make.sh [x]`, where `[x]` is one of the `.l` files sans extension - for example, `./make.sh json` will create `json.o` from `json.l`.

Because of how `make.sh` is written (and because some of my scanners require it), my library `libstack` from [this repo](https://github.com/EGBland/libliz) is required. Follow instructions from that repo to build, then copy `stack.h` to `./include` and `stack.a` to `./lib`.

## numhide.l
Replaces numbers with '?' and leaves the rest of the input untouched.

## json.l
A JSON scanner/tokeniser; an exercise adapted from Section 3 of Douglas Thain's
[Introduction to Compilers and Language Design](https://isbnsearch.org/isbn/9798655180260).
