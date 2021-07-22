#!/bin/bash

docker_name=''
db_user=''
db_name=''
from_path=''

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
    --path=*|--from-path=*)
    from_path="${i#*=}"
    shift # past argument=value
    ;;
    --docker=*|--docker-name=*)
    docker_name="${i#*=}"
    shift # past argument=value
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

exit 1;
fi

if [ "${from_path: -4}" == ".sql" ]; then
  ziped=false
elif [ "${from_path: -7}" == ".sql.gz" ]; then
  ziped=true
else
  echo "bad dump extension"
  exit 1;
fi;


#export_dt=$(date '+%Y-%m-%d_%H-%M-%S')
#export_db_name="${from_path}/${db_name}_${export_dt}"
#extension="sql"

if [ "$docker_name" != '' ]; then
  info="import from docker"
  file_name=$(echo "/$from_path" | sed -e 's/\/.*\///g')
  docker cp "${from_path}" "${docker_name}":/
  if [ "$ziped" == true ]; then
    echo "${info} compressed"
    docker exec -ti "${docker_name}" bash -c 'zcat /'"${file_name}"' | mysql -u'"${db_user}"' -p '"${db_name}"''
  else
    docker exec -ti "${docker_name}" bash -c 'cat /'"${file_name}"' | mysql -u'"${db_user}"' -p '"${db_name}"''
  fi
else
  info="import from local"
  if [ "$ziped" == true ]; then
    echo "${info} compressed"
    zcat "${from_path}" | mysql -u"${db_user}" -p "${db_name}"
  else
    cat "${from_path}" | mysql -u"${db_user}" -p "${db_name}"
  fi
fi

#echo "dump done";

exit 0;
