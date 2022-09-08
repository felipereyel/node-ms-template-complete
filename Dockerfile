FROM node:14-alpine AS base
WORKDIR /app/

FROM base as builder
COPY package.json package-lock.json tsconfig.json ./
RUN npm install
COPY ./src ./src
RUN npm run build
RUN npm prune --production

FROM base as release
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/build ./build
USER node
CMD node ./build/main.js
