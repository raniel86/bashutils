#!/bin/bash

item=$(basename "$1")
name="${item%.*}"

tar pczvf ${name}.tar.gz ${item}

exit 0
