# Variables
COMPOSE = docker compose -f srcs/docker-compose.yml

# Directories for volumes (must be /home/login/data/)
WP_DATA := /home/eabourao/data/wordpress
DB_DATA := /home/eabourao/data/mariadb

# Default target
all:
	@mkdir -p $(WP_DATA) $(DB_DATA)
	$(COMPOSE) up -d --build

# Stop containers
down:
	$(COMPOSE) down

# Stop + remove containers + remove images
clean: down
	$(COMPOSE) down --rmi all -v

# Full clean (containers, images, volumes, networks)
fclean: clean
	docker system prune -a --volumes -f

# Rebuild from scratch
re: fclean all

.PHONY: all down clean fclean re