# FlexStudy
Scanners and tokenisers written in "fast lexical analyser generator" (flex). Generate the scanners with `./make.sh [x]`, where `[x]` is one of the `.l` files sans extension - for example, `./make.sh json` will create `json.o` from `json.l`.

## numhide.l
Replaces numbers with '?' and leaves the rest of the input untouched.

## json.l
A JSON scanner/tokeniser; an exercise adapted from Section 3 of Douglas Thain's
[Introduction to Compilers and Language Design](https://isbnsearch.org/isbn/9798655180260).
