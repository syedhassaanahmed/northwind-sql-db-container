# northwind-sql-db-container
![Docker](https://github.com/syedhassaanahmed/northwind-sql-db-container/actions/workflows/docker-publish.yml/badge.svg)

This docker container initializes SQL Server 2022 with [Northwind database](https://github.com/Microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs). These are the steps to build and run the container;

- To build the container, execute `docker build . -t nwndsqldbimg`

OR

- In order to override the default SA password, execute

```bash
docker build . \
    --build-arg MSSQL_SA_PASSWORD=<YourStrong!Passw0rd> \
    -t nwndsqldbimg
```

- Run the container by executing `docker run -p 1433:1433 -d --name nwndsqldbcont nwndsqldbimg`
- Check logs if the container successfully started `docker logs nwndsqldbcont`
- Connect to the SQL Server using Management Studio/Azure Data Studio.
- Verify that the new database `Northwind` exists with the correct tables.
- If you'd like to automate the verification of database and table creation, you can execute the script `smoke-test.sh`. 
