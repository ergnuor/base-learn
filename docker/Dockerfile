FROM node:22-bullseye

USER root

RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/base-learn
#    && chown node:node /home/base-learn

#USER node

VOLUME /home/base-learn

#CMD ["tail", "-f", "/dev/null"]
