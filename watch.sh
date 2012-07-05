#! /bin/bash

# TODO Maybe make this a Cakefile.
coffee --watch --compile . &
sass --watch style.sass:style.css &
