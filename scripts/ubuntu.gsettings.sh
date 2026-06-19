#!/usr/bin/env bash

for schema in $(gsettings list-schemas); do
    gsettings list-recursively
    echo ""
done
