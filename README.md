# 🤠 Giddyup Admin Console

A beautiful, dark-themed administrative dashboard for managing a distributed VPS infrastructure connected via WireGuard mesh network.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Docker](https://img.shields.io/badge/docker-ready-green.svg)
![React](https://img.shields.io/badge/react-18.2.0-blue.svg)

## 🌟 Features

- **Real-time Infrastructure Monitoring** - Monitor CPU, RAM, and disk usage across all nodes
- **WireGuard Mesh Visualization** - Visual representation of your VPS mesh network
- **Service Status Tracking** - Track Docker containers and services across all nodes
- **Responsive Design** - Works on desktop, tablet, and mobile
- **Dark Theme** - Easy on the eyes with orange/slate color scheme
- **Docker Integration** - One-click deployment with Docker Compose

## 📸 Screenshots

### Dashboard Overview
![Dashboard](https://via.placeholder.com/800x400/1e293b/f97316?text=Dashboard+Overview)

### Infrastructure Nodes
![Nodes](https://via.placeholder.com/800x400/1e293b/a855f7?text=Infrastructure+Nodes)

## 🏗️ Architecture

This repository contains two main components:

### 1. Landing Page (`landing/`)
- Modern, responsive marketing site for Giddyup.cloud
- Static HTML with Tailwind CSS
- Showcases the Gay Cowboy Network infrastructure
- Deployed at `https://giddyup.cloud`

### 2. Admin Console (`admin/`)
- React-based administrative dashboard
- Real-time infrastructure monitoring
- Manages a 3-node WireGuard mesh network:
  - **Hub VPS** (10.0.0.1) - Gateway & Management (Traefik, Portainer, File Browser)
  - **Media VPS** (10.0.0.2) - Streaming Services (Jellyfin)
  - **Worker VPS** (10.0.0.3) - Development & DNS (Code Server, Pi-hole)
- Deployed at `https://admin.giddyup.cloud`

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Traefik reverse proxy running
- DNS configured for `admin.yourdomain.com`

### One-Line Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/YOUR_USERNAME/giddyup-admin/main/install.sh)
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/giddyup-admin.git
cd giddyup-admin
```

2. Configure your domain in `docker-compose.yml`:
```yaml
- "traefik.http.routers.giddyup-admin.rule=Host(`admin.yourdomain.com`)"
- "traefik.http.routers.giddyup-admin-secure.rule=Host(`admin.yourdomain.com`)"
```

3. Deploy:
```bash
docker-compose up -d
```

4. Access your admin console:
```
https://admin.yourdomain.com
```

## 📁 Project Structure

```
giddyup-admin/
├── docker-compose.yml       # Docker Compose configuration
├── install.sh              # One-line installation script
├── app/
│   ├── package.json        # Node.js dependencies
│   ├── vite.config.js      # Vite configuration
│   ├── index.html          # HTML entry point
│   └── src/
│       ├── main.jsx        # React entry point
│       └── App.jsx         # Main dashboard component
└── README.md
```

## 🔧 Configuration

### Environment Variables

The dashboard uses these environment variables (set in `docker-compose.yml`):

```yaml
environment:
  - NODE_ENV=production
```

### Customizing Infrastructure Data

Edit `app/src/App.jsx` and modify the `nodes` array to match your infrastructure:

```javascript
const nodes = [
  {
    id: 1,
    name: 'VPS 1 - The Hub',
    hostname: 'giddyup.cloud',
    ip: '23.94.198.158',
    internalIp: '10.0.0.1',
    // ... more configuration
  },
  // Add your nodes here
];
```

## 🛠️ Development

### Local Development

```bash
cd app
npm install
npm run dev
```

The dev server will start at `http://localhost:3000`

### Building for Production

```bash
cd app
npm run build
```

Built files will be in `app/dist/`

## 🐳 Docker

### Build Custom Image

```bash
docker build -t giddyup-admin:latest .
```

### Run with Docker Compose

```bash
docker-compose up -d
```

### View Logs

```bash
docker logs -f giddyup-admin-console
```

### Stop and Remove

```bash
docker-compose down
```

## 🔐 Security

- The admin console is protected by Traefik's middleware
- SSL certificates are automatically managed by Let's Encrypt
- Docker socket is mounted read-only for container stats
- No authentication is built-in - use Traefik's BasicAuth or ForwardAuth middleware

### Adding Basic Authentication

Add to your `docker-compose.yml` labels:

```yaml
- "traefik.http.routers.giddyup-admin-secure.middlewares=admin-auth"
- "traefik.http.middlewares.admin-auth.basicauth.users=admin:$$apr1$$..." # htpasswd hash
```

## 📊 Monitoring

The dashboard displays:

- ✅ Node status (online/offline)
- 📈 CPU usage percentage
- 💾 RAM usage percentage
- 💿 Disk usage percentage
- 🐳 Docker service status
- 🔒 WireGuard tunnel connections

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [React](https://reactjs.org/)
- Styled with [Tailwind CSS](https://tailwindcss.com/)
- Icons from [Lucide React](https://lucide.dev/)
- Deployed with [Docker](https://www.docker.com/)
- Reverse proxy by [Traefik](https://traefik.io/)

## 📧 Support

For issues, questions, or suggestions:

- 🐛 [Open an issue](https://github.com/YOUR_USERNAME/giddyup-admin/issues)
- 💬 [Start a discussion](https://github.com/YOUR_USERNAME/giddyup-admin/discussions)

---

Made with ❤️ by the Gay Cowboy Network 🤠
