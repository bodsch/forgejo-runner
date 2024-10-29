FROM archlinux:base
LABEL maintainer="bodsch <bodo@boone-schulz.de>"


RUN \
  # update package tree
  pacman \
    --sync \
    --refresh && \
  pacman \
    --noconfirm \
    --sync \
    --sysupgrade \
    --download && \
  pacman \
    --noconfirm \
    --sync \
    --sysupgrade

RUN \
  pacman \
    --noconfirm \
    --sync \
      archlinux-keyring

RUN \
  pacman \
    --noconfirm \
    --sync \
      dbus-broker-units \
      systemd \
      procps \
      pacman-contrib && \
  pacman \
    --noconfirm \
    --sync \
      ansible \
      git \
      python-setuptools \
      sudo \
      openssh \
      gawk \
      unzip \
      tar \
      rsync \
      curl \
      fuse \
      cmake \
      shellcheck \
      docker \
      docker-buildx \
      docker-compose \
      podman \
      buildah \
      nodejs

RUN \
  sed -i -e 's/\(driver.*=\).*/\1 "vfs"/g' /etc/containers/storage.conf && \
  sed -i -e 's/\(short-name-mode.*=\).*/\1 "permissive"/g' /etc/containers/registries.conf

RUN \
  systemctl set-default multi-user.target && \
  systemctl disable getty@tty1.service && \
  # cleanup
  paccache \
    --remove \
    --keep 0 && \
  pacman \
    --noconfirm \
    --sync \
    -cc && \
  rm -rf \
    /tmp/* \
    /usr/bin/find \
      /usr/lib/ -type d -name __pycache__ -exec rm -rf {} 2> /dev/null \; || true

LABEL \
  org.opencontainers.image.authors="Bodo Schulz <bodo@boone-schulz.de>" \
  maintainer="Bodo Schulz <bodo@boone-schulz.de>"
