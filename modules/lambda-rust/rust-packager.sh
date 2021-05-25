#!/bin/bash
echo "source $SOURCE_PATH"
echo "package $PACKAGE_NAME"
echo "zip $OUTPUT_ZIP"
cd $SOURCE_PATH
DOT_CARGO_DIR=.cargo

rm -rf $OUTPUT_ZIP

rustup target add x86_64-unknown-linux-musl

if [ ! -d $DOT_CARGO_DIR ]; then
    echo "Adding .cargo directory and config file"
    mkdir $DOT_CARGO_DIR
    echo $'[target.x86_64-unknown-linux-musl]\nlinker = "x86_64-linux-musl-gcc"' > $DOT_CARGO_DIR/config
fi

cargo build --release --target x86_64-unknown-linux-musl
cp ./target/x86_64-unknown-linux-musl/release/$PACKAGE_NAME ./bootstrap && zip $OUTPUT_ZIP bootstrap && rm bootstrap
