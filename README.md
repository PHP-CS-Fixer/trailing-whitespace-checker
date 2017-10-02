Trailing whitespaces checker
============================

This little bash script recursively iterates all files in the current directory and reports those that have lines with trailing whitespaces. In case a file is found, the script will exit with status code `3`, or `0` otherwise.

Installation
------------

Copy the [check-trailing-whitespaces file](./check-trailing-whitespaces) in a directory that is part of your `PATH` so it can be executed globally.

Usage
-----

Just run the script:

`$ check-trailing-whitespace`
