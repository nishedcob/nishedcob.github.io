#! /bin/bash

pip_install() {
    pip install -r requirements.txt
}

build_en() {
    ninja2 -j index.md.j2 < <(yq '.' <(cat universal.yaml en.yaml)) > index.md
}

build_es() {
    ninja2 -j index.md.j2 < <(yq '.' <(cat universal.yaml es.yaml)) > es/index.md
}

build_all() {
    build_en
    build_es
}

case "$1" in
    en)
        pip_install
        build_en
        ;;
    es)
        pip_install
        build_es
        ;;
    ci | all)
        pip_install
        build_all
        ;;
    *)
        echo "Available options:"
        printf "\ten\tBuild English\n"
        printf "\tes\tBuild Spanish\n"
        printf "\tci\tAlias for Build All\n"
        printf "\tall\tBuild All\n"
        ;;
esac
