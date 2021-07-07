#! /bin/bash

if which dokku >/dev/null; then
    echo "dokku exists"
else
    echo "dokku does not exist"
fi