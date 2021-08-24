#!/bin/bash
echo "source $SOURCE_PATH"
echo "output $OUTPUT_PATH"
echo "package $PACKAGE_NAME"
cd $SOURCE_PATH

export GO111MODULE=on
GOOS=linux go build -ldflags '-s -w' -o $OUTPUT_PATH/$PACKAGE_NAME $SOURCE_PATH/.
