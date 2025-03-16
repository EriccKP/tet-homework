# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm prune --production

# Stage 2: Runtime
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app /app
RUN adduser -D appuser && chown -R appuser /app
USER appuser
EXPOSE 3000
CMD ["node", "time.js"]