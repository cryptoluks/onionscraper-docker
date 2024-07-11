#!/usr/bin/env bash
docker run \
  -v $(pwd)/roms:/roms \
  -v $(pwd)/config.ini:/root/.skyscraper/config.ini \
  -it ghcr.io/cryptoluks/onionscraper-docker \
  onionscraper -a
