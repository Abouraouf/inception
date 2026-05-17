# Inception

*This project has been created as part of the 42 curriculum by eabourao.*

## Description

Inception is a system administration project that requires setting up a small infrastructure of Docker containers. The project uses Docker Compose to orchestrate three services: NGINX (with TLSv1.2/TLSv1.3), WordPress with PHP-FPM, and MariaDB. The goal is to understand containerization, service isolation, persistent storage, and secure communication between containers.

---

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- A Linux machine or virtual machine
- The domain `eabourao.42.fr` must point to `127.0.0.1` 

### Installation and Execution

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd inception_42
   ```

2. Create the required host directories for persistent storage:
   ```bash
   mkdir -p /home/eabourao/data/wordpress
   mkdir -p /home/eabourao/data/mariadb
   ```

3. Copy `.env.example` to `.env` and fill in your credentials:
   ```bash
   cp srcs/.env.example srcs/.env
   nano srcs/.env
   ```

4. Build and start the project:
   ```bash
   make
   ```

5. Access the website at `https://eabourao.42.fr` (accept the self-signed certificate warning).

### Makefile Commands

| Command        | Action                                              |
|----------------|-----------------------------------------------------|
| `make`         | Build and start all containers                      |
| `make down`    | Stop and remove containers                          |
| `make clean`   | Stop containers and remove images                   |
| `make fclean`  | Full cleanup (containers, images, volumes, networks)|
| `make re`      | Full rebuild from scratch                           |

---

## Resources

### Documentation

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress CLI Documentation](https://wp-cli.org/)
- [MariaDB Documentation](https://mariadb.com/kb/en/)

### AI Usage

This project was developed with assistance from an AI assistant (Claude, by Anthropic). The AI helped with:

- Understanding Docker concepts (images, containers, volumes, networks)
- Debugging entrypoint scripts and configuration files
- Explaining TLS/SSL certificate generation with OpenSSL
- Writing and refining Dockerfiles for MariaDB, WordPress, and NGINX
- Structuring the `docker-compose.yml` file with named volumes and custom network
- Creating the Makefile and documentation

All AI-generated code was reviewed, tested, and understood before inclusion in the project.

---

## Project Description

### Docker and Containerization

Docker is a platform that packages applications and their dependencies into lightweight, isolated units called containers. Unlike virtual machines, containers share the host operating system kernel, making them faster to start and more resource-efficient.

### Source Files Structure

```
inception_42/
├── Makefile
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   └── tools/entrypoint.sh
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/www.conf
        │   └── tools/entrypoint.sh
        └── nginx/
            ├── Dockerfile
            └── conf/nginx.conf
```

### Design Choices

- **Base Image:** Debian 12 (Bookworm) – the penultimate stable version as Debian 13 is now current. Debian was chosen over Alpine for easier debugging and familiarity with `apt-get`.
- **Services:** Each service runs in its own container for isolation and separation of concerns.
- **Entrypoint Scripts:** Custom scripts handle service initialization, waiting for dependencies, and starting the main process as PID 1.

---

## Virtual Machines vs Docker

| Aspect           | Virtual Machine           | Docker Container                    |
|------------------|---------------------------|-------------------------------------|
| Guest OS         | Full OS (GBs)             | None (shares host kernel)           |
| Startup Time     | Minutes                   | Seconds                             |
| Disk Usage       | GBs per VM                | MBs per container                   |
| Memory Overhead  | High                      | Low                                 |
| Isolation        | Hardware-level            | Process-level (namespaces)          |

## Secrets vs Environment Variables

| Aspect       | Environment Variables (`.env`) | Docker Secrets                              |
|--------------|-------------------------------|---------------------------------------------|
| Storage      | Plain text in `.env` file     | Encrypted at rest                           |
| Access       | Available to all containers   | Mounted only to specified containers        |
| Git Safety   | Must be in `.gitignore`       | Cannot be committed                         |
| Use Case     | Development (Inception mandatory) | Production (recommended for bonus)      |

This project uses a `.env` file as required by the subject. The `.env` file is excluded from Git via `.gitignore`.

## Docker Network vs Host Network

| Aspect      | Docker Network                         | Host Network                              |
|-------------|----------------------------------------|-------------------------------------------|
| Isolation   | Containers have their own network stack | Container uses host's network directly   |
| DNS Resolution | Automatic service discovery by name | Must use host ports                      |
| Security    | Isolated (default)                     | No isolation (subject forbids `network: host`) |
| Use Case    | Multi-container communication (Inception) | Performance-critical applications     |

This project uses a custom bridge network named `inception` to allow containers to communicate by service name (e.g., WordPress reaches MariaDB via `mariadb:3306`).

## Docker Volumes vs Bind Mounts

| Aspect      | Docker Volumes                  | Bind Mounts                      |
|-------------|----------------------------------|----------------------------------|
| Management  | Docker manages location          | User manages host path           |
| Portability | High (works anywhere)            | Low (path must exist)            |
| Backup      | Easy (`docker volume inspect`)   | Manual                           |
| Use Case    | Production data persistence      | Development (live code updates)  |

The subject requires named volumes with data stored at `/home/eabourao/data/`. This project uses named volumes configured as bind mounts via `driver_opts` to satisfy both requirements.

---

## License

This project was created for educational purposes at 42 Network.