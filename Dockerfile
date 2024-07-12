FROM docker.io/library/ubuntu:24.04 as builder

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

RUN <<-EOF
    echo "APT::Get::Assume-Yes true;" > /etc/apt/apt.conf.d/90assumeyes
    apt-get update
    apt-get install \
        g++ \
        gcc \
        git \
        make \
        p7zip-full \
        qt5-qmake \
        qtbase5-dev \
        qtbase5-dev-tools \
        qtchooser \
        sudo \
        wget
    rm -rf /var/lib/apt/lists/*
EOF

RUN <<-EOF
    cd /tmp && git clone --depth 1 https://github.com/Gemba/skyscraper
EOF

RUN <<-EOF
    cd /tmp/skyscraper
    ./build.sh
EOF

FROM docker.io/library/ubuntu:24.04

RUN <<-EOF
    echo "APT::Get::Assume-Yes true;" > /etc/apt/apt.conf.d/90assumeyes
    apt-get update
    apt-get install \
        qtbase5-dev \
        xmlstarlet
    rm -rf /var/lib/apt/lists/*
EOF

COPY --from=builder /tmp/skyscraper/aliasMap.csv /usr/local/etc/skyscraper/aliasMap.csv
COPY --from=builder /tmp/skyscraper/artwork.xml /usr/local/etc/skyscraper/artwork.xml
COPY --from=builder /tmp/skyscraper/artwork.xml.example1 /usr/local/etc/skyscraper/artwork.xml.example1
COPY --from=builder /tmp/skyscraper/artwork.xml.example2 /usr/local/etc/skyscraper/artwork.xml.example2
COPY --from=builder /tmp/skyscraper/artwork.xml.example3 /usr/local/etc/skyscraper/artwork.xml.example3
COPY --from=builder /tmp/skyscraper/artwork.xml.example4 /usr/local/etc/skyscraper/artwork.xml.example4
COPY --from=builder /tmp/skyscraper/cache/priorities.xml.example /usr/local/etc/skyscraper/cache/priorities.xml.example
COPY --from=builder /tmp/skyscraper/config.ini.example /usr/local/etc/skyscraper/config.ini.example
COPY --from=builder /tmp/skyscraper/docs/ARTWORK.md /usr/local/etc/skyscraper/ARTWORK.md
COPY --from=builder /tmp/skyscraper/docs/CACHE.md /usr/local/etc/skyscraper/CACHE.md
COPY --from=builder /tmp/skyscraper/docs/CACHE.md /usr/local/etc/skyscraper/cache/CACHE.md
COPY --from=builder /tmp/skyscraper/docs/IMPORT.md /usr/local/etc/skyscraper/import/IMPORT.md
COPY --from=builder /tmp/skyscraper/hints.xml /usr/local/etc/skyscraper/hints.xml
COPY --from=builder /tmp/skyscraper/import/definitions.dat.example1 /usr/local/etc/skyscraper/import/definitions.dat.example1
COPY --from=builder /tmp/skyscraper/import/definitions.dat.example2 /usr/local/etc/skyscraper/import/definitions.dat.example2
COPY --from=builder /tmp/skyscraper/mameMap.csv /usr/local/etc/skyscraper/mameMap.csv
COPY --from=builder /tmp/skyscraper/mobygames_platforms.json /usr/local/etc/skyscraper/mobygames_platforms.json
COPY --from=builder /tmp/skyscraper/peas.json /usr/local/etc/skyscraper/peas.json
COPY --from=builder /tmp/skyscraper/platforms_idmap.csv /usr/local/etc/skyscraper/platforms_idmap.csv
COPY --from=builder /tmp/skyscraper/README.md /usr/local/etc/skyscraper/README.md
COPY --from=builder /tmp/skyscraper/resources/boxfront.png /usr/local/etc/skyscraper/resources/boxfront.png
COPY --from=builder /tmp/skyscraper/resources/boxside.png /usr/local/etc/skyscraper/resources/boxside.png
COPY --from=builder /tmp/skyscraper/resources/frameexample.png /usr/local/etc/skyscraper/resources/frameexample.png
COPY --from=builder /tmp/skyscraper/resources/maskexample.png /usr/local/etc/skyscraper/resources/maskexample.png
COPY --from=builder /tmp/skyscraper/resources/scanlines1.png /usr/local/etc/skyscraper/resources/scanlines1.png
COPY --from=builder /tmp/skyscraper/resources/scanlines2.png /usr/local/etc/skyscraper/resources/scanlines2.png
COPY --from=builder /tmp/skyscraper/screenscraper_platforms.json /usr/local/etc/skyscraper/screenscraper_platforms.json
COPY --from=builder /tmp/skyscraper/Skyscraper /usr/local/bin/Skyscraper
COPY --from=builder /tmp/skyscraper/supplementary/scraperdata/check_screenscraper_json_to_idmap.py /usr/local/bin/check_screenscraper_json_to_idmap.py
COPY --from=builder /tmp/skyscraper/supplementary/scraperdata/convert_platforms_json.py /usr/local/bin/convert_platforms_json.py
COPY --from=builder /tmp/skyscraper/supplementary/scraperdata/peas_and_idmap_verify.py /usr/local/bin/peas_and_idmap_verify.py
COPY --from=builder /tmp/skyscraper/tgdb_developers.json /usr/local/etc/skyscraper/tgdb_developers.json
COPY --from=builder /tmp/skyscraper/tgdb_genres.json /usr/local/etc/skyscraper/tgdb_genres.json
COPY --from=builder /tmp/skyscraper/tgdb_platforms.json /usr/local/etc/skyscraper/tgdb_platforms.json
COPY --from=builder /tmp/skyscraper/tgdb_publishers.json /usr/local/etc/skyscraper/tgdb_publishers.json

RUN mkdir -p /root/.skyscraper
COPY onionscraper/onionscraper /usr/local/bin/onionscraper
COPY onionscraper/skyscraper/artwork.xml /root/.skyscraper/artwork.xml
