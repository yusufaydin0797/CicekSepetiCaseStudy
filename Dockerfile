FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY CQRSDeneme/*.csproj ./CQRSDeneme/
COPY CQRSDeneme.Core/*.csproj ./CQRSDeneme.Core/
COPY CQRSDeneme.Data/*.csproj ./CQRSDeneme.Data/
RUN dotnet restore

# copy everything else and build app
COPY CQRSDeneme/. ./CQRSDeneme/
COPY CQRSDeneme.Core/. ./CQRSDeneme.Core/
COPY CQRSDeneme.Data/. ./CQRSDeneme.Data/

WORKDIR /app/CQRSDeneme
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=build /app/CQRSDeneme/out ./

CMD ASPNETCORE_URLS=http://*:$PORT dotnet CQRSDeneme.dll