#!/bin/bash

json=$1
header=${2:-0}

if [ $header -eq 0 ]; then
	php -r "echo '\"' . implode('\",\"', json_decode('$json', true)) . '\"' . PHP_EOL;"
else
	php -r "echo '\"' . implode('\",\"', array_keys(json_decode('$json', true))) . '\"' . PHP_EOL;"
fi

exit 0
