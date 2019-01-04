#!/bin/sh

echo 'Sleeping 10s..'
sleep 10

while true; do
    echo 'Cloning git repo..'
    git clone https://github.com/hjacobs/srcco.de.git
    (
    cd srcco.de
    echo 'Pulling git repo..'
    git pull
    rm -fr .doit*
    echo 'Building static HTML with Nikola..'
    nikola build
    )
    echo 'Sleeping 90s..'
    sleep 90
done

