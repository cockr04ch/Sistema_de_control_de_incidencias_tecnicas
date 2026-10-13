FROM oven/bun:1

WORKDIR /usr/src/app

COPY package.json bun.lock ./
COPY backend/package.json ./backend/
RUN bun install --frozen-lockfile --filter ./backend

COPY backend/ ./backend/

RUN chmod -R 777 /usr/src/app

WORKDIR /usr/src/app/backend
EXPOSE 8080
CMD ["bun", "run", "server.js"]