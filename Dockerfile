FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY *.sln .
COPY ExampleTracing/*.csproj ./ExampleTracing/
RUN dotnet restore

COPY ExampleTracing/. ./ExampleTracing/
WORKDIR /src/ExampleTracing
RUN dotnet publish -c Release -o /app/out /p:PublishTrimmed=true /p:PublishSingleFile=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

EXPOSE 80

ENTRYPOINT ["dotnet", "ExampleTracing.dll"]