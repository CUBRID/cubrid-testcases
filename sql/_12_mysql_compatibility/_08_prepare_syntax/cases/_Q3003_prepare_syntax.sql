--+ holdcas on;
set system parameters 'compat_mode=mysql';

PREPARE STMT from 'create table t1 (id int auto_increment, name varchar(100), age smallint, a1 CHAR(2000),b2 VARCHAR(2000),c3 NCHAR(2000),d4 NCHAR VARYING(2000),e5 BIT(2000),f6 BIT VARYING(2000),g7 NUMERIC,h8 DECIMAL,i9 INTEGER ,j10 SMALLINT,k11 MONETARY,l12 FLOAT,m13 REAL,n14 DOUBLE PRECISION,o15 DATE,p16 TIME,q17 TIMESTAMP)';
execute stmt;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (''a'', 30), (?, ?)';
execute stmt using 'b', 31;
execute stmt using 'c', 32;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (''?'', ?)';
execute stmt using 43;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (?, ?)';
execute stmt using '?', 43;
DEALLOCATE PREPARE stmt;

------------------ the following is error
PREPARE STMT from 'insert into t1(name, age) values ('a1', 30)';
execute stmt;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (?, ?)';
execute stmt using '?', 'a', 10;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (?, ?)';
execute stmt using '?', 'ax';
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (''?'', ?)';
execute stmt using 'x', 43;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert ? t1(name, age) values ('a1', 30)';
execute stmt using 'into';
DEALLOCATE PREPARE stmt;

PREPARE STMT from '? into t1(name, age) values ('b1', 30)';
execute stmt using 'insert';
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (?, ?)';
execute stmt;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (?, ?)';
execute stmt using;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (?, ?)';
execute stmt using 1,2,3;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (?, ?)';
execute stmt USING , ,;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (?, ?)';
execute stmt using , , ,;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (?, ?)';
execute stmt using ,3,43;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (?, ?)';
execute stmt using 3,43,;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values ('c1', 999); update t1 set age=-age where age=999';
execute stmt;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t1(name, age) values (''c1'', 999); update t1 set age=-age where age=999';
execute stmt;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'select 888 a from ?';
execute stmt using 'db_root';
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'select ? col from db_root';
execute stmt using 10+1;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'select ? col from db_root';
execute stmt using 10;
DEALLOCATE PREPARE stmt;
execute stmt using 10;

PREPARE STMT from 'select ? col from db_root';
DEALLOCATE PREPARE stmt;
execute stmt using 10;

------------------ end

PREPARE STMT from 'select ''############################################'' as this_is_seperator_line from db_root';
execute stmt;
DEALLOCATE PREPARE stmt;


PREPARE STMT from 'select 10 from db_root';
PREPARE STMT from 'select 20 as this_value_should_be_20 from db_root';
PREPARE STMT from 'select 30 as this_value_should_be_30 from db_root';
execute stmt;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'create table t2 (id int, name varchar(100), age smallint)';
execute stmt;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'insert into t2 (select id, name ,age from t1 where id <>0 )';
execute stmt;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'select * from t1 order by id asc';
execute stmt;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'select * from t2 order by id asc';
execute stmt;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'drop table t1';
execute stmt;
DEALLOCATE PREPARE stmt;

PREPARE STMT from 'drop table t2';
execute stmt;
DEALLOCATE PREPARE stmt;

drop table t1;
drop table t2;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
