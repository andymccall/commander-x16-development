FROM ubuntu:24.04

RUN apt update -y && apt upgrade -y

RUN apt install build-essential git -y
RUN mkdir -p ~/src ~/tools
RUN git clone https://github.com/cc65/cc65.git ~/src/cc65
RUN cd ~/src/cc65/ && nice make -j2 && make install PREFIX=~/tools