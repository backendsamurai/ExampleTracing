FROM grafana/alloy:latest

COPY ./alloy/config.alloy /etc/alloy/config.alloy

EXPOSE 4317 

ENTRYPOINT [ "alloy","run", "/etc/alloy/config.alloy" ]