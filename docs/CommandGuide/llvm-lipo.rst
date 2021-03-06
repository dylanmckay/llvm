llvm-lipo - LLVM tool for manipulating universal binaries
=========================================================

SYNOPSIS
--------

:program:`llvm-lipo` [*filenames...*] [*options*]

DESCRIPTION
-----------
:program:`llvm-lipo` can create universal binaries from Mach-O files, extract regular object files from universal binaries, and display architecture information about both universal and regular files.

COMMANDS
--------
:program:`llvm-lipo` supports the following mutually exclusive commands:

.. option:: -help, -h

  Display usage information and exit. 

.. option:: -version

  Display the version of this program. 

.. option:: -verify_arch  <architecture 1> [<architecture 2> ...]

  Take a single input file and verify the specified architectures are present in the file. 
  If so then exit with a status of 0 else exit with a status of 1.

BUGS
----

To report bugs, please visit <http://llvm.org/bugs/>.
