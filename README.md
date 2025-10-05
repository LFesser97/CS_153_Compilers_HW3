# HW3: LLVMlite backend


The [instructions for this homework](doc/hw3-llvmlite.html) are in the `doc` directory. 
Note that in the same directory is the [LLVMlite specification](doc/llvmlite.html).


Quick Start:

1. open the folder in VSCode
2. start an OCaml sandbox terminal
3. run `make test` from the command line
4. open `bin/backend.ml`

Using ``oatc``
--------------
oatc acts like the clang compiler.  Given several .ll, .c, and .o
files, it will compile the .ll files to .s files (using the CS1530
backend) and then combine the results with the .c and .o files to
produce an executable named a.out.  You can also compile the .ll files
using clang instead of the CS1530 backend, which can be useful for
testing purposes.


* To run the automated test harness do:

        ./oatc --test

* To compile ll files using the CS1530 backend:

        ./oatc path/to/foo.ll

  - creates output/foo.s   backend assembly code
  - creates output/foo.o   assembled object file
  - creates a.out          linked executable

  NOTE: by default the .s and .o files are created in a directory
  called output, and the filenames are chosen so that multiple runs of
  the compiler will not overwrite previous outputs.  foo.ll will be
  compiled first to foo.s then foo\_1.s, foo\_2.s, etc.

* To compile ll files using the clang backend:

        ./oatc --clang path/to/foo.ll

* Useful flags:

  | Flag              | Description                                                                                 |
  |-------------------|---------------------------------------------------------------------------------------------|
  | --print-ll        | echoes the ll program to the terminal                                                       |
  | --print-x86       | echoes the resulting .s file to the terminal                                                |
  | --interpret-ll    | runs the ll file through the reference interpreter and outputs the results to the console   |
  | --execute-x86     | runs the resulting a.out file natively (for both CS1530 backend and clang-compiled code) |
  | -v                | generates verbose output, showing which commands are used for linking, etc.                 |
  | -op ``<dirname>`` | change the output path [DEFAULT=output]                                                     |
  | -o                | change the generated executable's name [DEFAULT=a.out]                                      |
  | -S                | stop after generating .s files                                                              |
  | -c                | stop after generating .o files                                                              |
  | -h or --help      | display the list of options                                                                 |

* Example uses:

  Run the test case llprograms/factrect.ll using the CS1530 backend:


          ./oatc --execute-x86 llprograms/factrect.ll 
          --------------------------------------------------------------- Executing: a.out
          * a.out returned 120
