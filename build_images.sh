#!/bin/bash
if [ "$TRAVIS_BRANCH" == "releases" ]; then
    docker build -t karfai42/xa-lichen:production -f Dockerfile.production .
fi

if [ ! -z "$TRAVIS_TAG" ]; then
    docker build -t karfai42/xa-lichen:$TRAVIS_TAG -t karfai42/xa-lichen:latest -f Dockerfile.production .
fi
