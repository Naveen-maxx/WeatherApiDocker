# Stage 1: Build and publish
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /src

COPY . .

RUN dotnet restore

RUN dotnet publish -c Release \
    -r linux-x64 \
    --self-contained true \
    -o /app/publish \
    /p:PublishSingleFile=true \
    /p:UseAppHost=true

# Stage 2: Run the self-contained application
FROM mcr.microsoft.com/dotnet/runtime-deps:10.0 AS final

WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:80

EXPOSE 80

ENTRYPOINT ["./WeatherApi"]
