NAME=prerender
REPO=rise-vision/$(NAME)
VERSION=1.0.0


.PHONY: bash start stop remove clean build push runbash cleanbuild

all: build

build:
		docker build -t $(REPO):$(VERSION) .

push:
		docker push $(REPO)

run:
		@if ! docker ps -a | awk '{ print $$2 }' | grep -q -F $(REPO):$(VERSION); then \
			docker run -d --name $(NAME) $(REPO):$(VERSION); \
		fi


stop:
		@if docker ps | awk '{ print $$2 }' | grep -q -F $(REPO):$(VERSION); then \
			docker stop $(NAME); \
		fi


start:
		@if ! docker ps | awk '{ print $$2 }' | grep -q -F $(REPO):$(VERSION); then \
			docker start $(NAME); \
		fi

remove:
		@if docker ps -a | awk '{ print $$2 }' | grep -q -F $(REPO):$(VERSION); then \
			docker rm -f $(NAME); \
		fi


bash: CMD = bash
bash: build runbash

runbash:
		docker run -t -i -d $(REPO):$(VERSION) $(CMD)

clean:
		@if docker images $(REPO) | awk '{ print $$1 }'; then\
			docker rmi $(REPO):latest $(REPO):$(VERSION) || true;\
		fi

cleanbuild: stop remove clean build


