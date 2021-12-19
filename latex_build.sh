#! /bin/bash

set_dir() {
    cd /src/doc
}

build() {
    FILE=${1:-"main.tex"}
    pdflatex $FILE
    pdflatex $FILE
}

build_en() {
    build
}

build_es() {
    cd es
    build
    cd ..
}

build_all() {
    build_en
    build_es
}

clean() {
    FILE=${1:-"main"}
    for suffix in "aux" "log" "out" ; do
        rm -v ${FILE}.${suffix}
    done
}

clean_en() {
    clean
}

clean_es() {
    cd es
    clean
    cd ..
}

clean_all() {
    clean_en
    clean_es
}

set_dir
case "$1" in
    en)
        build_en
        clean_en
        ;;
    es)
        build_es
        clean_es
        ;;
    ci | all)
        build_all
        clean_all
        ;;
    *)
        echo "Available options:"
        printf "\ten\tBuild English\n"
        printf "\tes\tBuild Spanish\n"
        printf "\tci\tAlias for Build All\n"
        printf "\tall\tBuild All\n"
        ;;
esac
