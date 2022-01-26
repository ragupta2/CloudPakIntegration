FROM golang:1.17.6-bullseye


ARG GOPATH_ARG="/go"
ARG GOVERSION=1.17.6

ENV GOVERSION=${GOVERSION}   \
    GOPATH=$GOPATH_ARG \
    GOTAR=go${GOVERSION}.linux-amd64.tar.gz \
    ORG="github.com/ibm-messaging"

# Create location for the git clone and MQ installation
RUN mkdir -p $GOPATH/src $GOPATH/bin $GOPATH/pkg \
  && chmod -R 777 $GOPATH \
  && mkdir -p $GOPATH/src/$ORG \
  && cd /tmp       \
  && wget -nv https://dl.google.com/go/${GOTAR} \
  && tar -xf ${GOTAR} \
  && mv go /usr/lib/go-${GOVERSION} \
  && rm -f ${GOTAR} \
  && mkdir -p /opt/mqm \
  && chmod a+rx /opt/mqm

# Install gcc tools
# RUN apk add build-base

# RUN apt-get install curl

# Location of the downloadable MQ client package \
ENV RDURL="https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqdev/redist" \
    RDTAR="IBM-MQC-Redist-LinuxX64.tar.gz" \
    VRMF=9.2.4.0
# Install the MQ client from the Redistributable package. This also contains the
# header files we need to compile against. Setup the subset of the package
# we are going to keep - the genmqpkg.sh script removes unneeded parts
ENV genmqpkg_incnls=1 \
    genmqpkg_incsdk=1 \
    genmqpkg_inctls=1
RUN cd /opt/mqm \
&& curl -LO "$RDURL/$VRMF-$RDTAR" \
&& tar -zxf ./*.tar.gz \
&& rm -f ./*.tar.gz \
&& bin/genmqpkg.sh -b /opt/mqm

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY mqtlsput-interval.go ./
COPY ssl/* ./certs/


ENV QUEUE_MANAGER=QUICKSTART \
    QUEUE=IN \
    CHANNEL=EXT.CONN2 \
    CONNECTION_URL="nativeha-ini-qm-ibm-mq-qm-mq.itzroks-550004s7y8-gwvb8u-4b4a324f027aea19c5cbc0c3275c4656-0000.us-south.containers.appdomain.cloud(443)" \
    KEY_PATH="/app/certs/clientkey"

RUN go build -o /mq-golang-put-interval

EXPOSE 8080

CMD [ "/mq-golang-put-interval" ]