#!/bin/bash

help()
{
   echo "Import a mysql or pgsql database from your local on a docker database or local database."
   echo
   echo "[--db|--db-name]               (Required) The database name."
   echo "[--path|--from-path]           (Required) The location where the dump is on your machine."
   echo "[--docker|--docker-name]       (Optional) If you're using a docker, the container name."
   exit 0
}

docker_name=''
db_user=''
db_name=''
from_path=''
is_psql_db=false

for i in "$@"
do
case $i in
    --db=*|--db-name=*)
      db_name="${i#*=}"
      shift
    ;;
    --user=*|--db-user=*)
      db_user="${i#*=}"
      shift
    ;;
    --path=*|--from-path=*)
      from_path="${i#*=}"
      shift
    ;;
    --docker=*|--docker-name=*)
      docker_name="${i#*=}"
      shift
    ;;
    -h|--help)
      help
    ;;
    *)
    ;;
esac
done

if [ "$db_user" == '' ] || [ "$db_name" == '' ] || [ "$from_path" == '' ]; then
  if [ "$db_user" == '' ]; then
    echo "Missing argument db user. Use --user=XXX or --db-user=XXX"
  fi;
  if [ "$db_name" == '' ]; then
    echo "Missing argument db name. Use --db=XXX or --db-name=XXX"
  fi;
  if [ "$from_path" == '' ]; then
    echo "Missing from path. Please add your local path where your dump is with --path=XXX or --out-path=XXX"
  fi;

  echo
  echo "Use -h or --help to get more information"

exit 1;
fi

if [ "${from_path: -4}" == ".sql" ]; then
  zipped=false
elif [ "${from_path: -7}" == ".sql.gz" ]; then
  zipped=true
elif  [ "${from_path: -6}" == ".pgsql" ]; then
  is_psql_db=true
else
  echo "bad dump extension"
  exit 1;
fi;

if [ "$docker_name" != '' ]; then
  info="import from docker"
  file_name=$(echo "/$from_path" | sed -e 's/\/.*\///g')
  docker cp "${from_path}" "${docker_name}":/
  if [ $is_psql_db == true ]; then
    docker exec -ti "${docker_name}" bash -c 'cat /'"${file_name}"' | psql -U '"${db_user}"' -d '"${db_name}"''
  else
    if [ "$zipped" == true ]; then
      echo "${info} compressed"
      docker exec -ti "${docker_name}" bash -c 'zcat /'"${file_name}"' | mysql -u'"${db_user}"' -p '"${db_name}"''
    else
      docker exec -ti "${docker_name}" bash -c 'cat /'"${file_name}"' | mysql -u'"${db_user}"' -p '"${db_name}"''
    fi
  fi
else
  info="import from local"
  if [ $is_psql_db == true ]; then
      cat "${from_path}" | psql -U "${db_user}" -d "${db_name}"
  else
    if [ "$zipped" == true ]; then
      echo "${info} compressed"
      zcat "${from_path}" | mysql -u"${db_user}" -p "${db_name}"
    else
      cat "${from_path}" | mysql -u"${db_user}" -p "${db_name}"
    fi
  fi
fi

echo "Import done"

exit 0;
