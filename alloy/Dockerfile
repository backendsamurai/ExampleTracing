FROM grafana/alloy:v1.9.0

COPY ./alloy/config.alloy /etc/alloy/config.alloy

EXPOSE 8080

ENTRYPOINT [ "alloy","run", "/etc/alloy/config.alloy" ]