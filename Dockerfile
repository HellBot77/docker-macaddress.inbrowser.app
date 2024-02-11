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
    pnpm run build

FROM pierrezemb/gostatic

COPY --from=build /macaddress.inbrowser.app/dist /srv/http
EXPOSE 8043