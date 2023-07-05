FROM xiaoyaliu/alist:latest AS builder
COPY xiaoyapatch.sh /
RUN sh /xiaoyapatch.sh && \
    rm -rf /xiaoyapatch.sh

FROM scratch
COPY --from=builder / /
VOLUME /opt/alist/data/
VOLUME /data/
WORKDIR /opt/alist/
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/opt/alist/alist","server","--no-prefix"]