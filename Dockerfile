FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers

COPY ./app/*.csproj ./
RUN dotnet restore

# copy everything else and build app
COPY ./app ./
WORKDIR /app/
RUN dotnet publish -c Release -o out


FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
WORKDIR /app
ENV ASPNETCORE_URLS http://*:5090
EXPOSE 5090/tcp
COPY --from=build /app/out ./
ENTRYPOINT ["dotnet", "app.dll"]