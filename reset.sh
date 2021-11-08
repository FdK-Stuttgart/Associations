#!/usr/bin/env sh

rm -rf var/lib/mysql/data/*
rm -rf var/log/*
git checkout etc/ \
    map/app-map/src/environments/ \
    map/app-form/src/environments/
