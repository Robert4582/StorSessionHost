#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["SessionHost/SessionHost.csproj", "SessionHost/"]
RUN dotnet restore "SessionHost/SessionHost.csproj"
COPY . .
WORKDIR "/src/SessionHost"
RUN dotnet build "SessionHost.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SessionHost.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SessionHost.dll"]