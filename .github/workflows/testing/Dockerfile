ARG BASE_IMAGE=debian:stable-slim
FROM ${BASE_IMAGE}

WORKDIR /robohelp
COPY . .

RUN ./setup.sh && bash -n /tmp/robohelp/robohelp.sh

ENTRYPOINT ["/tmp/robohelp/robohelp.sh"]
CMD ["-h"]
