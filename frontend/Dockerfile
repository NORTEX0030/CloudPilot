FROM node:latest as build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Stage 2: Run
FROM node:alpine

# Set a non-root user for better security
RUN adduser -D appuser
USER appuser

WORKDIR /app

COPY --from=build /app .

EXPOSE 3000

CMD ["node", "app.js"]
