FROM alpine:3.9

# copied from https://github.com/draga79/nikola/blob/alpine/Dockerfile
RUN apk --no-cache add python3 python3-dev alpine-sdk libxml2 py3-lxml zlib-dev libjpeg jpeg-dev && pip3 install -U pip setuptools wheel

RUN pip3 install Nikola jinja2 aiohttp watchdog && rm -Rf /root/.cache/

# the main Bash loop
ADD run.sh /

EXPOSE 8000

WORKDIR /workdir

CMD ["/run.sh"]
