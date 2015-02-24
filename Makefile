NAME=prerender
REPO=rise-vision/$(NAME)
VERSION = 1.0.0


.PHONY: admin bash start build

all: build

build:
		docker build -t $(REPO):$(VERSION) .

push:
		docker push $(REPO)

start:
		docker run -d --name $(NAME) $(REPO):$(VERSION)

stop:
		docker stop $(NAME)

rm:
		docker rm -f $(NAME)

bash: CMD = bash
bash: build run

run:
		docker run -t -i -d $(REPO):$(VERSION) $(CMD)

clean:
		docker rmi $(REPO):latest $(REPO):$(VERSION) || true

