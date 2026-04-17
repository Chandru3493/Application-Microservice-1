FROM nginx:alpine

# Create necessary directories and set permissions for nginx
RUN mkdir -p /var/cache/nginx \
    && mkdir -p /var/run \
    && chown -R nginx:nginx /var/cache/nginx \
    && chown -R nginx:nginx /var/run \
    && chown -R nginx:nginx /etc/nginx/conf.d \
    && touch /var/run/nginx.pid \
    && chown nginx:nginx /var/run/nginx.pid

# Copy app source
COPY src/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Run as nginx user (security best practice)
USER nginx

CMD ["nginx", "-g", "daemon off;"]