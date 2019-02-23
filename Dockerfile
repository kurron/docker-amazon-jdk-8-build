# Follows guidance from http://www.projectatomic.io/docs/docker-image-author-guidance/

FROM amazoncorretto:8

MAINTAINER Ron Kurr <kurr@kurron.org>

# Create non-root user
RUN groupadd --system microservice --gid 444 && \
useradd --uid 444 --system --gid microservice --home-dir /home/microservice --create-home --shell /sbin/nologin --comment "Docker image user" microservice && \
chown -R microservice:microservice /home/microservice

# default to being in the user's home directory
WORKDIR /home/microservice

# Set standard Java environment variables
ENV JAVA_HOME /usr/lib/jvm/java
ENV JDK_HOME /usr/lib/jvm/java
ENV JRE_HOME /usr/lib/jvm/jre

# have Ansible examine the container, by default
CMD ["/usr/bin/ansible", "all", "--inventory=localhost,", "--verbose", "--connection=local", "-m setup"]

# ---- watch your layers and put likely mutating operations here -----

ENV DOCKER_VERSION=18.09.2
ENV COMPOSE_VERSION=1.23.2

# Install SCMs and tools needed for installation
RUN yum --assumeyes install tar git

# Install Ansible
RUN curl --fail --silent --show-error --location --remote-name https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install ansible

# Install Docker client so we can build images and run automated tests
RUN curl --fail --silent --show-error --location --remote-name https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
    tar --strip-components=1 -xvzf docker-${DOCKER_VERSION}.tgz -C /usr/local/bin && \
    rm -f docker-${DOCKER_VERSION}.tgz && \
    chmod 0555 /usr/local/bin/docker

# Install Docker Compose so we can build images and run automated tests
RUN curl --fail --silent --show-error --location "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" --output /usr/local/bin/docker-compose && \
    chmod 0555 /usr/local/bin/docker-compose

# remember to switch to the non-root user in child images
# Switch to the non-root user
# USER microservice
