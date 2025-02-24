# Use the official nginx alpine image
FROM nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy static files to nginx directory
COPY index.html /usr/share/nginx/html/
COPY config.json /usr/share/nginx/html/
COPY favicon.png /usr/share/nginx/html/
COPY images/* /usr/share/nginx/html/images/

# Use custom nginx config to handle SPA routing
RUN echo 'server { \
    listen 80; \
    server_name _; \
    root /usr/share/nginx/html; \
    index index.html; \
    # Enable gzip compression \
    gzip on; \
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript; \
    # Cache static assets \
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ { \
        expires 1y; \
        add_header Cache-Control "public, no-transform"; \
    } \
    # Handle routing \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# No need for CMD or ENTRYPOINT as they are inherited from nginx:alpine 