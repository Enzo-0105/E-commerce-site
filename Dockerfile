FROM node:16-alpine3.16 AS build
WORKDIR /app
COPY . .
RUN npm install --force && npm run build 

FROM nginx:1.26-alpine-slim
COPY --from=build /app/build/* /usr/share/nginx/html
RUN rm /usr/share/nginx/html/index.html
COPY index.html /usr/share/nginx/html
RUN cd  /usr/share/nginx/html/js && mv main.25d28253.chunk.js main.e193f4e6.chunk.js
RUN cd  /usr/share/nginx/html/js && mv main.25d28253.chunk.js.map main.e193f4e6.chunk.js.map
CMD ["nginx", "-g", "daemon off;"]
