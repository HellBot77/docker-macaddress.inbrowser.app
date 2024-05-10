FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/InBrowserApp/macaddress.inbrowser.app.git && \
    cd macaddress.inbrowser.app && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /macaddress.inbrowser.app
COPY --from=base /git/macaddress.inbrowser.app .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm build

FROM lipanski/docker-static-website

COPY --from=build /macaddress.inbrowser.app/dist .
