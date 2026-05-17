COMPOSE = docker compose -f srcs/docker-compose.yml

WP_DATA := /home/eabourao/data/wordpress
DB_DATA := /home/eabourao/data/mariadb

all:
	@mkdir -p $(WP_DATA) $(DB_DATA)
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean: down
	$(COMPOSE) down --rmi all -v

fclean: clean
	docker system prune -a --volumes -f

re: fclean all
