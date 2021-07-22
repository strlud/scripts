#!/bin/bash

docker_name=''
db_user=''
db_name=''
out_path=''
db_type=''
zipped=false

help()
{
   echo "Export a mysql or pgsql database from local or docker."
   echo
   echo "[--db-type]                   (Required) The type of database. Can be mysql or pgsql"
   echo "[--db|--db-name]              (Required) The database name."
   echo "[--path|--out-path]           (Required) The location of the dump."
   echo "[--docker|--docker-name]      (Optional) If you're using a docker, the container name."
   echo "[-zipped|-z]                  (Optional) Option for mysql database type to export as tar.gz (file weight reduce by 10)."
   exit 0
}

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
    --path=*|--out-path=*)
      out_path="${i#*=}"
      shift
    ;;
    --docker=*|--docker-name=*)
      docker_name="${i#*=}"
      shift
    ;;
    --db-type=*)
      db_type="${i#*=}"
      shift
    ;;
    -zipped|-z)
      zipped=true
      shift
    ;;
    -h|--help)
      help
    ;;
      *)
    ;;
esac
done

if [ "$db_user" == '' ] || [ "$db_name" == '' ] || [ "$out_path" == '' ]; then
  if [ "$db_user" == '' ]; then
    echo "Missing argument db user. Use --user=XXX or --db-user=XXX"
  fi;
  if [ "$db_name" == '' ]; then
    echo "Missing argument db name. Use --db=XXX or --db-name=XXX"
  fi;
  if [ "$out_path" == '' ]; then
    echo "Missing out path. Please add your local path where export the db with --path=XXX or --out-path=XXX"
  fi;
  echo
  echo "Use -h or --help to get more information"

exit 1;
fi

export_dt=$(date '+%Y-%m-%d_%H-%M-%S')
export_db_name="${out_path}/${db_name}_${export_dt}"
extension="sql"
if [ "$zipped" == true ]; then
  extension="sql.gz"
fi

if [ "$docker_name" != '' ]; then
  info="dump from docker"

  if [ "$db_type" == 'mysql' ]; then
    if [ "$zipped" == true ]; then
        echo "${info} compressed"
        docker exec -i "${docker_name}" mysqldump -u"${db_user}" -p "${db_name}" | gzip > "${export_db_name}.${extension}"
    else
        docker exec -i "${docker_name}" mysqldump -u"${db_user}" -p "${db_name}" > "${export_db_name}.${extension}"
    fi
  elif [ "$db_type" == 'pgsql' ]; then
    docker exec "${docker_name}" pg_dump -c -U "${db_user}" "${db_name}" > "${export_db_name}.pgsql"
  fi

else
  info="dump from local"

  if [ "$db_type" == 'mysql' ]; then
    if [ "$zipped" == true ]; then
      echo "${info} compressed"
      mysqldump -u"${db_user}" -p "${db_name}" | gzip > "${export_db_name}.${extension}"
    else
      mysqldump -u"${db_user}" -p "${db_name}" > "${export_db_name}.${extension}"
    fi
  elif [ "$db_type" == 'pgsql' ]; then
      pg_dump -c -U "${db_user}" "${db_name}" > "${export_db_name}.pgsql"
  fi
fi

echo "dump done";

exit 0;
