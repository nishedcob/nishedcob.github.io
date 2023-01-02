#! /bin/bash

pip_install() {
    pip install -r requirements.txt
}

generic_build() {
    TEMPLATE=$1
    OUTPUT=$2
    LANG=$3
    ninja2 -j $TEMPLATE < <(yq '.' <(cat universal.yaml ${LANG}.yaml)) > $OUTPUT
}

generic_md_build() {
    OUTPUT=$1
    LANG=$2
    generic_build index.md.j2 ${OUTPUT}.md $LANG
}

generic_latex_build() {
    OUTPUT=$1
    LANG=$2
    generic_build main.tex.j2 ${OUTPUT}.tex $LANG
}

build_en_md() {
    generic_md_build index en
}

build_es_md() {
    generic_md_build es/index es
}

build_en_web() {
    build_en_md
}

build_es_web() {
    build_es_md
}

build_en_latex() {
    generic_latex_build main en
}

build_es_latex() {
    generic_latex_build es/main es
}

build_en() {
    build_en_web
    build_en_latex
}

build_es() {
    build_es_web
    build_es_latex
}

build_all() {
    build_en
    build_es
}

build_ci() {
    build_all
}

case "$1" in
    en_latex) ## Build English LaTeX
        pip_install
        build_en_latex
        ;;
    es_latex) ## Build Spanish LaTeX
        pip_install
        build_es_latex
        ;;
    en_web) ## Build English Markdown (for Website)
        pip_install
        build_en_web
        ;;
    es_web) ## Build Spanish Markdown (for Website)
        pip_install
        build_es_web
        ;;
    en) ## Build English (LaTeX + Markdown for Website)
        pip_install
        build_en
        ;;
    es) ## Build Spanish (LaTeX + Markdown for Website)
        pip_install
        build_es
        ;;
    ci) ## Alias for Build All
        pip_install
        build_ci
        ;;
    all) ## Build English (LaTeX + Markdown for Website)
        pip_install
        build_all
        ;;
    *)
        echo "Available options:"
        sed -n '/sed/d; /) ## /s/) ## / | /p' $0 | column -ts '|'
        ;;
esac
