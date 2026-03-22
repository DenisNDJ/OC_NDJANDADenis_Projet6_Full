
ARG NODE_VERSION=24.11.1

FROM node:${NODE_VERSION}-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:1.27-alpine
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist/*/browser /app
EXPOSE 80