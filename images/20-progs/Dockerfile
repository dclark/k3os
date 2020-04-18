ARG REPO
ARG TAG
ARG VERSION
FROM ${REPO}/k3os-gobuild:${TAG} as gobuild

ENV LINUXKIT 3f56669576bac1a44cd61f5a9fa540976d33eeed

FROM gobuild as linuxkit
RUN git clone https://github.com/linuxkit/linuxkit.git $GOPATH/src/github.com/linuxkit/linuxkit
WORKDIR $GOPATH/src/github.com/linuxkit/linuxkit/pkg/metadata
RUN git checkout -b current $LINUXKIT
RUN gobuild -o /output/metadata

FROM gobuild as k3os
ARG VERSION
# COPY /cmd/ $GOPATH/src/github.com/rancher/k3os/cmd/
COPY /pkg/ $GOPATH/src/github.com/rancher/k3os/pkg/
COPY /main.go $GOPATH/src/github.com/rancher/k3os/
COPY /vendor/ $GOPATH/src/github.com/rancher/k3os/vendor/
WORKDIR $GOPATH/src/github.com/rancher/k3os
RUN gobuild -o /output/k3os

FROM gobuild
COPY --from=linuxkit /output/ /output/
COPY --from=k3os /output/ /output/
WORKDIR /output
RUN git clone --branch v0.7.0 https://github.com/ahmetb/kubectx.git \
 && chmod -v +x kubectx/kubectx kubectx/kubens
# ETCD
ENV ETCD_VER v3.4.7
ENV ETCD_DOWNLOAD_URL https://github.com/etcd-io/etcd/releases/download
RUN apk -U add curl
RUN curl -L ${ETCD_DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o ${ETCD_VER}-linux-amd64.tar.gz
RUN mkdir etcd && tar xzvf ${ETCD_VER}-linux-amd64.tar.gz --strip-components=1 -C etcd
RUN rm -f ${ETCD_VER}-linux-amd64.tar.gz