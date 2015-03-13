FROM debian:wheezy

MAINTAINER Marian Steinbach <marian@giantswarm.io>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
	apt-get install -y -q --no-install-recommends \
	python2.7 python-pip build-essential python-dev

RUN pip install Flask Flask-Cache requests redis

RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ADD server.py /server.py

ENTRYPOINT ["python", "-u", "server.py"]

EXPOSE 5000
