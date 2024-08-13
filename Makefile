NAME=inception

all: $(NAME)

$(NAME):
	mkdir -p /home/hgu/data
	mkdir -p /home/hgu/data/DB
	mkdir -p /home/hgu/data/wordpress
	docker-compose -f ./srcs/docker-compose.yml up --build -d

down:
	docker-compose -f ./srcs/docker-compose.yml down

clean:
	docker-compose -f ./srcs/docker-compose.yml down
	docker volume rm srcs_mariaDB_volume
	docker volume rm srcs_wordpress_volume
	# rm -rf /home/hgu/data

re: clean all

.PHONY : all clean down re 