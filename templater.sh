#! /bin/bash

pip install -r requirements.txt
ninja2 -j index.md.j2 < <(yq '.' <(cat universal.yaml en.yaml)) > index.md
