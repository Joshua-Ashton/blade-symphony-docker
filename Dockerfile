FROM ubuntu:18.04
MAINTAINER Joshua Ashton <joshua@punyhuman.com>

ARG username=anonymous
ARG password=
ARG steam_guard=

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y lib32gcc1 curl
RUN mkdir -p /valve
WORKDIR /valve
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
RUN chmod +x steamcmd.sh
RUN ./steamcmd.sh +login ${username} ${password} ${steam_guard} +force_install_dir /valve/game +app_update 761260 validate +quit
RUN cp -f /valve/linux64/steamclient.so /valve/game/bin/linux64/steamclient.so

WORKDIR /valve/game/bin
CMD ["/bin/bash", "-c", "/valve/game/bin/srcds_run.sh -game /valve/game/berimbau ${COMMAND_LINE}"]
