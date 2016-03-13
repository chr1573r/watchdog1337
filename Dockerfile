# WD1337 does not actually support Docker, but this should kinda work
# How-to use:
# (make your changes to settings.cfg and hosts.lst)
# docker build -t wd .
# docker run wd

FROM debian
RUN mkdir -p /watchdog1337
WORKDIR /watchdog1337/

ENV TERM=xterm

COPY . /watchdog1337

CMD ["./watchdog1337.sh"]
