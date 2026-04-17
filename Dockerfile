FROM nginx:alpine

# Create necessary directories and set permissions for nginx
RUN mkdir -p /var/cache/nginx \
    && mkdir -p /var/run \
    && chown -R nginx:nginx /var/cache/nginx \
    && chown -R nginx:nginx /var/run \
    && chown -R nginx:nginx /etc/nginx/conf.d \
    && touch /var/run/nginx.pid \
    && chown nginx:nginx /var/run/nginx.pid

# Override default nginx config to listen on unprivileged port 8080
RUN sed -i 's/listen\s*80;/listen 8080;/g; s/listen\s*\[::\]:80;/listen [::]:8080;/g' /etc/nginx/conf.d/default.conf

# Copy app source
COPY src/ /usr/share/nginx/html/

# Expose port 8080 (non-root nginx cannot bind to privileged port 80)
EXPOSE 8080

# Run as nginx user (security best practice)
USER nginx

CMD ["nginx", "-g", "daemon off;"]