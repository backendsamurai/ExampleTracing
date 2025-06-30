FROM grafana/alloy:latest

COPY ./alloy/config.alloy /etc/alloy/config.alloy

ENTRYPOINT [ "alloy","run", "/etc/alloy/config.alloy" ]