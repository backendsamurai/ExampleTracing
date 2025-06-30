# build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# copy csproj file and restore packages
COPY Examples.AspNetCore.csproj .
RUN dotnet restore

# copy project files and make publish of app
COPY . .
RUN dotnet publish -c Release -o /out

# final stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /out .
ENV ASPNETCORE_URLS="http://0.0.0.0:8080"
ENTRYPOINT [ "dotnet", "Examples.AspNetCore.dll" ]