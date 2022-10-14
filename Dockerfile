ARG SQL_SERVER_VERSION=2022
FROM mcr.microsoft.com/mssql/server:${SQL_SERVER_VERSION}-latest

ARG MSSQL_SA_PASSWORD=<YourStrong!Passw0rd>

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD

WORKDIR /northwind
ADD --chown=mssql https://raw.githubusercontent.com/microsoft/sql-server-samples/master/samples/databases/northwind-pubs/instnwnd.sql ./
COPY --chown=mssql ./init-db.sh ./

RUN chmod +x ./init-db.sh

ENTRYPOINT ./init-db.sh & /opt/mssql/bin/sqlservr