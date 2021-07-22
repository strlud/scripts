#!/bin/bash

docker_name=''
db_user=''
db_name=''
out_path=''
ziped=false

for i in "$@"
do
case $i in
    --db=*|--db-name=*)
    db_name="${i#*=}"
    shift # past argument=value
    ;;
    --user=*|--db-user=*)
    db_user="${i#*=}"
    shift # past argument=value
    ;;
    --path=*|--out-path=*)
    out_path="${i#*=}"
    shift # past argument=value
    ;;
    --docker=*|--docker-name=*)
    docker_name="${i#*=}"
    shift # past argument=value
    ;;
    -ziped)
    ziped=true
    shift # past argument=value
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

exit 1;
fi

export_dt=$(date '+%Y-%m-%d_%H-%M-%S')
export_db_name="${out_path}/${db_name}_${export_dt}"
extension="sql"
if [ "$ziped" == true ]; then
  extension="sql.gz"
fi

if [ "$docker_name" != '' ]; then
  info="dump from docker"
  if [ "$ziped" == true ]; then
    echo "${info} compressed"
    docker exec -i "${docker_name}" mysqldump -u"${db_user}" -p "${db_name}" | gzip > "${export_db_name}.${extension}"
  else
    docker exec -i "${docker_name}" mysqldump -u"${db_user}" -p "${db_name}" > "${export_db_name}.${extension}"
  fi
else
  info="dump from local"
  if [ "$ziped" == true ]; then
    echo "${info} compressed"
    mysqldump -u"${db_user}" -p "${db_name}" | gzip > "${export_db_name}.${extension}"
  else
    mysqldump -u"${db_user}" -p "${db_name}" > "${export_db_name}.${extension}"
  fi
fi

echo "dump done";

exit 0;
