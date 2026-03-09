FROM nixos/nix:latest AS builder
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

WORKDIR /chall
COPY . .

RUN nix build .#default

ENTRYPOINT [ "/chall/result/bin/demo" ]
