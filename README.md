# scripts

This repo will contains useful scripts

## Summary

* [Get started](#get-started)
* [Export a db (faster)](#exportdbsh)
* [Import a db (faster)](#importdbsh)

### Get Started
* Clone this repository : ```git clone git@github.com:strlud/scripts.git```
* Add the script executable : ``chmod +x importDb.sh exportDb.sh``
* If you want to use these scripts everywhere on your machine, you can create a symlink (or cp the script) in your ``/usr/local/bin`` for example :
  * ``sudo cp "$PWD/exportDb.sh" /usr/local/bin/exportDb``
  * ``sudo cp "$PWD/importDb.sh" /usr/local/bin/importDb``
* You can now do ``exportDb -h`` or ``importDb -h`` to see help message everywhere

### exportDb.sh

This script allow you to export a mysql or pgsql database.
You could export a db from a docker or your local machine. Compressed or not.
The dump's name will be : db_name-year_month_day-hour_minute_second.[pgsql|sql|sql.gz]

Example : 
You must specify the type of database you want to export

* Export a MySQL database from your local machine NOT compressed : ```exportDb --db-type=mysql --user=root --db=my_db --path=/tmp/dump```
* Export a MySQL database from your local machine compressed: ```exportDb --db-type=mysql --user=root --db=my_db --path=/tmp/dump -zipped```
* Export a PostgresSQL database from your local machine : ```exportDb --db-type=pgsql --user=root --db=my_db --path=/tmp/dump```
* Export a MySQL database from a docker NOT compressed : ```exportDb --db-type=mysql --user=root --db=my_db --path=/tmp/dump --docker-name=db_docker```
* Export a MySQL database from a docker compressed : ```exportDb --db-type=mysql --user=root --db=my_db --path=/tmp/dump --docker-name=db_docker -zipped```
* Export a PostgresSQL database from a docker : ```exportDb --db-type=pgsql --user=root --db=my_db --path=/tmp/dump --docker-name=db_docker```

Good to know: 
* ```--db-type``` the type of db you want to export : ``pgsql`` or ``mysql``
* ```--user``` is an alias of ```--db-user``` is the name of your user db
* ```--db``` is an alias of ```--db-name``` is the name of your database
* ```--path``` is an alias of ```--out-path``` is the path on your local machin where you want the dump
* ```--docker``` is an alias of ```--docker-name``` is the name of your docker which contains the mysql server (optional)
* ```-zipped``` is an option to tell to export the db compressed (optional) ONLY for ``mysql`` database
  
### importDb.sh

This script allow you to import a mysql or pgsql database
It should be used after the export. 

Example of how to use it : 

* Import database with a mysql local : ```importDb --user=root --db=my_db --path=/tmp/dump/my_db.sql```
* Import database into a docker : ```importDb --user=root --db=my_db --path=/tmp/dump/my_db.sql --docker=gt_bdd```

Good to know:
* ```--user``` is an alias of ```--db-user``` is the name of your user db
* ```--db``` is an alias of ```--db-name``` is the name of your database
* ```--path``` is an alias of ```--from-path``` is the path on your local machine where the dump is. 
  The extension must be ```.sql``` or ```.sql.gz``` or ``.pgsql``
* ```--docker``` is an alias of ```--docker-name``` is the name of your docker which contains the mysql server (optional)
