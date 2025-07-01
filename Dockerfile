# build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# copy csproj file and restore packages
COPY Examples.AspNetCore.csproj .
RUN dotnet restore

# copy project files and make publish of app
COPY . .
RUN dotnet publish -c Release -o /out

# Stage 2: Final container with Alloy + .NET API
FROM grafana/alloy:latest

# Install required packages and .NET Runtime
ENV DOTNET_VERSION=8.0

# Install prerequisites
RUN apt-get update && \
    apt-get install -y wget apt-transport-https ca-certificates gnupg && \
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y aspnetcore-runtime-${DOTNET_VERSION} && \
    rm -rf /var/lib/apt/lists/*

# Set up workdir
WORKDIR /app

# Copy built .NET app
COPY --from=build /out /app

COPY alloy /etc/alloy

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENV ASPNETCORE_URLS="http://0.0.0.0:8080"

EXPOSE 8080

ENTRYPOINT [ "/start.sh" ]