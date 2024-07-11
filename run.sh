#!/usr/bin/env bash
mkdir -p cache
docker run \
  -v $(pwd)/roms:/roms \
  -v $(pwd)/cache:/root/.skyscraper/cache \
  -v $(pwd)/config.ini:/root/.skyscraper/config.ini \
  -it ghcr.io/cryptoluks/onionscraper-docker \
  onionscraper -a
