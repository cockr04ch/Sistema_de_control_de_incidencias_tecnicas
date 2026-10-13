FROM oven/bun:1

WORKDIR /usr/src/app

COPY package.json bun.lock ./
COPY frontend/package.json ./frontend/
RUN bun install --frozen-lockfile --filter ./frontend

COPY frontend/ ./frontend/

ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

WORKDIR /usr/src/app/frontend
RUN bun run build
EXPOSE 5173
CMD ["bun", "run", "preview", "--", "--host", "0.0.0.0", "--port", "5173"]