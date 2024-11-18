FROM node:16-alpine3.16 AS build
WORKDIR /app
COPY . .
RUN npm install --force && npm run build

FROM nginx:1.26-alpine-slim
COPY --from=build /app/build/* /usr/share/nginx/html
RUN rm /usr/share/nginx/html/index.html
COPY index.html /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
