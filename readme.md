# Model 100 Stuff

This is an utterly unorganized and incomplete set of programs and files for TRS-80 Model 100. Mostly using git as versioned external storage here.

## Useful Stuff

`loadhx.ba` is a BASIC program that can read an Intel Hex format file into memory over the serial port. It currently opens `COM:88N1E` and begins `POKE`ing at `58000` (`$E290`). Currently only tested with a 50ms delay between bytes from the server (Tera Term). Menu options for address and `STAT` string coming _Eventually™_.
