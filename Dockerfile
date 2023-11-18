ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION}

# User settings
ARG USERNAME=appuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# annotation for OCI images
LABEL org.opencontainers.image.authors="Hector Molina <hector@hmolina.dev>" \
    org.opencontainers.image.url="https://hmolina.dev/" \
    org.opencontainers.image.vendor="darkenv" \
    org.opencontainers.image.title="bootstrap-ansible" \
    org.opencontainers.image.description="Testing bootstrap ansible script"

ENV TERM=xterm
ENV USER=${USERNAME}
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install basic packages and create non root user
RUN <<EOF
#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt dist-upgrade -y
apt-get install --no-install-recommends -y \
    sudo \
    locales \
    dumb-init
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
locale-gen en_US.UTF-8
groupadd --gid ${USER_GID} ${USERNAME}
useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/${USERNAME}
chmod 0440 /etc/sudoers.d/${USERNAME}
EOF

USER ${USERNAME}

WORKDIR /home/${USERNAME}

COPY *.sh ${PWD}

RUN ${PWD}/*.sh

# Use the init system as the entrypoint
ENTRYPOINT ["dumb-init", "--"]

# Invoke our main process. Make it a login shell so it loads .profile
CMD ["/usr/bin/bash --login"]
