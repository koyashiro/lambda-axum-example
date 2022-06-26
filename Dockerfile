FROM amazonlinux:2

RUN yum update -y \
  && yum install -y gcc zip
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal
ENV PATH=/root/.cargo/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /build

COPY Cargo.* /build/
RUN mkdir /build/src \
  && touch /build/src/lib.rs \
  && cargo build --release \
  && rm -rf /build/src

COPY src /build/src
RUN cargo build --release \
  && mv target/release/lambda-axum-example bootstrap \
  && strip --strip-all bootstrap \
  && zip deploy.zip bootstrap
