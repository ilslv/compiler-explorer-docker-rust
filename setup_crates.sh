#!/bin/bash

set -e # exit on any error

wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

mkdir /opt/compiler-explorer/lib/storage/data

mkdir tmp && cd tmp

yq eval '.crates[] | key' ../config.yml | while IFS= read -r i; do
    name=$(yq eval ".crates[$i].name" ../config.yml)
    version=$(yq eval ".crates[$i].version" ../config.yml)

    curl -L "https://crates.io/api/v1/crates/$name/$version/download" | tar -zxf -
    cd "$name-$version"
    cargo build --release
    find ./target/release/deps \( -name "*.rlib" -o -name "*.so" \) -exec \
        cp -pfrv '{}' '/opt/compiler-explorer/lib/storage/data/' ';'
    cd ..
done
