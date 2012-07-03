#! /bin/bash

# TODO Maybe make this a Cakefile.
coffee --watch --compile code.coffee &
sass --watch style.sass:style.css &
