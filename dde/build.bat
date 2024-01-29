rmdir /s/q build
mkdir build
pushd .
cd build

zasm --8080 -x ..\dde.asm -o .
zasm --8080 ..\dde.asm -o .

popd
