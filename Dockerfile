FROM node:16-alpine as BUILD

WORKDIR /usr/src/app
COPY package*.json .nvmrc tsconfig.json ./
COPY src ./src
RUN npm ci --ignore-scripts
RUN npm run build


FROM node:16-alpine
WORKDIR /usr/src/app
COPY --from=BUILD /usr/src/app/package*.json ./
RUN npm ci --omit=dev --ignore-scripts
COPY --from=BUILD /usr/src/app/dist ./dist

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD wget --no-verbose --tries=1 -qO- http://localhost/healthcheck || exit 1
EXPOSE 80

CMD ["node", "dist/index.js"]