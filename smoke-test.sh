#!/usr/bin/env bash
set -uo pipefail

IMAGE_NAME=nwndsqldbimg-smoketest
CONTAINER_NAME=nwndsqldbcont-smoketest
MSSQL_SA_PASSWORD="<YourStrong!Passw0rd>"

echo "Stopping and removing container $CONTAINER_NAME if already exists"
docker stop $CONTAINER_NAME || true && docker rm $CONTAINER_NAME || true

docker build . --build-arg MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD -t $IMAGE_NAME
docker run -d --name $CONTAINER_NAME $IMAGE_NAME

#do this in a loop because the timing for when the SQL instance is ready is indeterminate
RETRIES=60
DB_NAME="Northwind"
TABLE_NAME="[dbo].[EmployeeTerritories]"

for i in $(seq 1 1 $RETRIES)
do
    # "-h -1" SQLCMD flag is used to remove column headers from the output
    # "SET NOCOUNT ON;" before the intended SQL query is used to remove output such as "n row(s) affected"
    # xargs removes the leading and trailing spaces from the output
    SQL_CMD="/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P \"$MSSQL_SA_PASSWORD\" -d \"$DB_NAME\" -h -1 -Q \
        \"SET NOCOUNT ON; SELECT COUNT(1) FROM $TABLE_NAME\" | xargs"

    ROW_COUNT=$(docker exec $CONTAINER_NAME bash -c "$SQL_CMD")

    if [[ $? -eq 0 && $ROW_COUNT =~ ^[0-9]+$ && $ROW_COUNT -ge 1 ]];
    then
        echo "$TABLE_NAME row count is $ROW_COUNT"
        echo "$DB_NAME DB initialization successful"
        break
    else
        echo "$TABLE_NAME row count is $ROW_COUNT"
        echo "Waiting for $DB_NAME DB initialization. Attempt $i out of $RETRIES..."
        if [ $i = $RETRIES ];
        then
            echo "All retries ($RETRIES) exhausted"
            docker logs $CONTAINER_NAME
            exit 1
        else
            sleep 1
        fi
    fi
done

echo "Smoke test succeeded"
echo "Cleaning up container $CONTAINER_NAME"
docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
