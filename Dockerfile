# Minimalistisches nginx-basiertes Image
FROM nginx:alpine

# Entferne Standard nginx Seite
RUN rm -rf /usr/share/nginx/html/*

# Kopiere alle statischen Dateien einzeln
COPY index.html /usr/share/nginx/html/
COPY sitemap.xml /usr/share/nginx/html/
COPY robots.txt /usr/share/nginx/html/

# Falls vorhanden, Logo mitkopieren
COPY logo.png /usr/share/nginx/html/

# Erstelle die Nginx-Konfiguration ohne riskante Backslashes
RUN printf 'server {\n\
    listen 80;\n\
    server_name _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    gzip on;\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

# Exponiere Port 80
EXPOSE 80

# Starte nginx
CMD ["nginx", "-g", "daemon off;"]
