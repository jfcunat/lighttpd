
# s2i-lighttpd
FROM ubuntu

MAINTAINER Marc Despland <marc.despland@orange.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform to expose static web site with lighttpd" \
      io.k8s.display-name="builder lighttpd" \
      io.openshift.expose-services="8080:http" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.openshift.tags="builder, lighttpd."
RUN apt-get update && apt-get install -y lighttpd

COPY ./.s2i/bin /usr/libexec/s2i

RUN mkdir -p /opt/app-root/etc ; mkdir -p /opt/app-root/src
WORKDIR /opt/app-root/src

# Copy the lighttpd configuration file
COPY ./etc/ /opt/app-root/etc

RUN groupadd --gid 1001 s2i && useradd --gid 1001 --uid 1001 -m s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080