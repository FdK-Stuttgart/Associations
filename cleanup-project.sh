#!/usr/bin/env sh

set -x  # Print commands and their arguments as they are executed.
rm -rf \
   var/lib/mysql/data/* \
   var/log/* \
   ./node_modules/ \
   ./map/app-form/node_modules/ \
   ./map/app-map/node_modules/

git checkout etc/ \
    map/app-map/src/environments/ \
    map/app-form/src/environments/
