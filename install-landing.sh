#!/bin/bash

set -e

echo "🤠 Giddyup Landing Page - Installation Script"
echo "=============================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
echo -e "${RED}Please run as root or with sudo${NC}"
exit 1
fi

command -v docker >/dev/null 2>&1 || { echo -e "${RED}Docker is required but not installed.${NC}" >&2; exit 1; }
command -v docker-compose >/dev/null 2>&1 || command -v docker compose >/dev/null 2>&1 || { echo -e "${RED}Docker Compose is required but not installed.${NC}" >&2; exit 1; }

echo -e "${YELLOW}Enter your domain for the landing page (e.g., giddyup.cloud):${NC}"
read -p "Domain: " DOMAIN

if [ -z "$DOMAIN" ]; then
echo -e "${RED}Domain cannot be empty.${NC}"
exit 1
fi

echo ""
echo -e "${GREEN}Installing to: /opt/giddyup-landing${NC}"
echo -e "${GREEN}Domain: $DOMAIN${NC}"
echo ""

echo "⏹️  Stopping any existing containers…"
cd /opt/giddyup-landing 2>/dev/null && docker-compose down 2>/dev/null || true
docker rm -f giddyup-landing 2>/dev/null || true

echo "🧹 Cleaning up old files…"
rm -rf /opt/giddyup-landing
mkdir -p /opt/giddyup-landing

echo "📝 Creating configuration files…"

cat > /opt/giddyup-landing/docker-compose.yml << EOF
version: '3.8'

services:
giddyup-landing:
image: nginx:alpine
container_name: giddyup-landing
volumes:
- ./index.html:/usr/share/nginx/html/index.html:ro
- ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
networks:
- traefik_network
labels:
- "traefik.enable=true"
- "traefik.http.routers.giddyup-landing.rule=Host(\`${DOMAIN}\`)"
- "traefik.http.routers.giddyup-landing.entrypoints=web"
- "traefik.http.routers.giddyup-landing.middlewares=redirect-to-https"
- "traefik.http.routers.giddyup-landing-secure.rule=Host(\`${DOMAIN}\`)"
- "traefik.http.routers.giddyup-landing-secure.entrypoints=websecure"
- "traefik.http.routers.giddyup-landing-secure.tls=true"
- "traefik.http.routers.giddyup-landing-secure.tls.certresolver=letsencrypt"
- "traefik.http.services.giddyup-landing.loadbalancer.server.port=80"
- "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme=https"
- "traefik.http.middlewares.redirect-to-https.redirectscheme.permanent=true"
restart: unless-stopped

networks:
traefik_network:
external: true
EOF

cat > /opt/giddyup-landing/nginx.conf << 'EOF'
server {
listen 80;
server_name _;

```
root /usr/share/nginx/html;
index index.html;

add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;

gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

location / {
    try_files $uri $uri/ /index.html;
}

location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

}
EOF

echo "📥 Downloading landing page HTML…"
curl -sSL https://raw.githubusercontent.com/pupragnarok/giddyup-admin-backend/main/landing/index.html -o /opt/giddyup-landing/index.html

if [ ! -f /opt/giddyup-landing/index.html ]; then
echo -e "${RED}Failed to download index.html.${NC}"
exit 1
fi

echo ""
echo -e "${GREEN}✅ All files created successfully!${NC}"
echo ""

echo "🚀 Starting deployment…"
cd /opt/giddyup-landing
docker-compose up -d

echo ""
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}🎉 Landing Page Deployed!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Access your landing page at:"
echo -e "   ${GREEN}https://${DOMAIN}${NC}"
echo ""
echo "📝 Useful commands:"
echo "   View logs:    docker logs -f giddyup-landing"
echo "   Restart:      cd /opt/giddyup-landing && docker-compose restart"
echo "   Stop:         cd /opt/giddyup-landing && docker-compose down"
echo ""
echo "⚠️  Remember to add DNS A record: $DOMAIN → your-server-ip"
echo ""
echo "🤠 Happy wrangling!"
echo ""