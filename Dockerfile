# Minimalistisches nginx-basiertes Image für Static Site
FROM nginx:alpine

# Entferne Standard nginx Seite
RUN rm -rf /usr/share/nginx/html/*

# Kopiere alle statischen Dateien in das nginx root directory
COPY index.html /usr/share/nginx/html/
COPY sitemap.xml /usr/share/nginx/html/
COPY robots.txt /usr/share/nginx/html/

# Optional: Wenn du Logo/Favicon später hinzufügst:
# COPY logo.png /usr/share/nginx/html/
# COPY favicon.png /usr/share/nginx/html/

# nginx.conf optimiert für Single-Page Static Site
RUN echo 'server { \n\
    listen 80; \n\
    server_name _; \n\
    root /usr/share/nginx/html; \n\
    index index.html; \n\
    \n\
    # Gzip Kompression für bessere Performance \n\
    gzip on; \n\
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript; \n\
    \n\
    # Cache-Control Headers \n\
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ { \n\
        expires 1y; \n\
        add_header Cache-Control "public, immutable"; \n\
    } \n\
    \n\
    # Alle Anfragen auf index.html routen (für SPA-Support) \n\
    location / { \n\
        try_files $uri $uri/ /index.html; \n\
    } \n\
    \n\
    # Security Headers \n\
    add_header X-Frame-Options "SAMEORIGIN" always; \n\
    add_header X-Content-Type-Options "nosniff" always; \n\
    add_header X-XSS-Protection "1; mode=block" always; \n\
} \n' > /etc/nginx/conf.d/default.conf

# Exponiere Port 80
EXPOSE 80

# Starte nginx
CMD ["nginx", "-g", "daemon off;"]
