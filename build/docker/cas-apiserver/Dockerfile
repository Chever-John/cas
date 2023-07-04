FROM BASE_IMAGE
LABEL maintainer="<cheverjonathan@gmail.com>"

WORKDIR /opt/cas

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
      echo "Asia/Shanghai" > /etc/timezone && \
      mkdir -p /var/log/cas

COPY cas-apiserver /opt/cas/bin/

ENTRYPOINT ["/opt/cas/bin/cas-apiserver"]
CMD ["-c", "/etc/cas/cas-apiserver.yaml"]
