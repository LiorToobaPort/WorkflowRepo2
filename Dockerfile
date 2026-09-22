# Build Stage
FROM lacion/alpine-golang-buildimage:1.13 AS build-stage

LABEL app="build-WorkflowRepo2"
LABEL REPO="https://github.com/lacion/WorkflowRepo2"

ENV PROJPATH=/go/src/github.com/lacion/WorkflowRepo2

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ADD . /go/src/github.com/lacion/WorkflowRepo2
WORKDIR /go/src/github.com/lacion/WorkflowRepo2

RUN make build-alpine

# Final Stage
FROM lacion/alpine-base-image:latest

ARG GIT_COMMIT
ARG VERSION
LABEL REPO="https://github.com/lacion/WorkflowRepo2"
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL VERSION=$VERSION

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:/opt/WorkflowRepo2/bin

WORKDIR /opt/WorkflowRepo2/bin

COPY --from=build-stage /go/src/github.com/lacion/WorkflowRepo2/bin/WorkflowRepo2 /opt/WorkflowRepo2/bin/
RUN chmod +x /opt/WorkflowRepo2/bin/WorkflowRepo2

# Create appuser
RUN adduser -D -g '' WorkflowRepo2
USER WorkflowRepo2

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/opt/WorkflowRepo2/bin/WorkflowRepo2"]
