# northwind-sql-db-container
This docker container initializes SQL Server with [Northwind database](https://github.com/Microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs). These are the steps to build and run the container;

1. To build the container, execute `docker build . -t nwndsqldbimg`

OR

1. In order to override the default SQL Server version and SA password, execute

```bash
docker build . \
    --build-arg SQL_SERVER_VERSION=2022 \
    --build-arg MSSQL_SA_PASSWORD=<YourStrong!Passw0rd> \
    -t nwndsqldbimg
```

1. Run the container by executing `docker run -p 1433:1433 -d --name nwndsqldbcont nwndsqldbimg`
1. Check logs if the container successfully started `docker logs nwndsqldbcont`
1. Connect to the SQL Server using Management Studio/Azure Data Studio.
Verify that the new database `Northwind` exists with the correct tables.
