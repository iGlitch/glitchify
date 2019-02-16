#!/bin/sh
zip -r glitchify.zip . -x *.git* -x "*.zip" -x "*.DS_Store" -x "__MACOSX"

mkdir -p out
mv glitchify.zip out

echo "Done"
