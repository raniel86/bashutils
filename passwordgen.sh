#!/bin/bash

length=$1

if [ -v $length ]; then
	length=32
fi

pass=`< /dev/urandom tr -dc '!?@#_^$~A-Z-a-z-0-9' | head -c$length`

echo $pass

exit 0
