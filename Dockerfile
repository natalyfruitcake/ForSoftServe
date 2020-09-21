FROM alpine as pse
ARG PSE_VERSION=1.1.0
ADD https://github.com/cultureamp/parameter-store-exec/releases/download/v${PSE_VERSION}/parameter-store-exec-v${PSE_VERSION}-linux-amd64.tar.gz .
RUN tar -xvzf parameter-store-exec-v${PSE_VERSION}-linux-amd64.tar.gz

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine3.10 AS build
WORKDIR /app-build

# copy projects files
COPY . .

WORKDIR /app-build/MarketplaceService/Marketplace.API
RUN mkdir /app \
    && dotnet publish -c Release -o /app \
    && rm -rf /app/web.config \
    && rm -rf /app/appsettings.Development.json \
    && rm -rf /app/appsettings.Staging.json \
    && rm -rf /app/*.pdb \
    && ls -l /app

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine3.10 AS runtime
WORKDIR /app

COPY --from=build /app ./

ENV PATH=${PATH}:/${PWD}
COPY --from=pse /parameter-store-exec /usr/local/bin/parameter-store-exec

ARG ENVIRONMENT

ENV AWS_REGION us-east-1
ENV PARAMETER_STORE_EXEC_PATH=/$ENVIRONMENT/backend/marketplace

RUN /bin/sh -c 'chmod +x /usr/local/bin/parameter-store-exec'

ENTRYPOINT ["parameter-store-exec"]
CMD ["dotnet", "MarketplaceService.API.dll"]
