FROM grafana/alloy:latest

COPY ./alloy/config.alloy /etc/alloy/config.alloy

ENTRYPOINT ["/etc/alloy/alloy", "--config.file=/etc/alloy/config.alloy"]
