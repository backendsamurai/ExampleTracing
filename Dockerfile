FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY . ./ExampleTracing/
WORKDIR /src/ExampleTracing
RUN dotnet publish -c Release -o /app/out

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

ENV ASPNETCORE_URLS="http://0.0.0.0:8080"
ENTRYPOINT ["dotnet", "Examples.AspNetCore.dll"]