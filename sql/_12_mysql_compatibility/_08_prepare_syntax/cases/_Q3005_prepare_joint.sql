--+ holdcas on;
set system parameters 'compat_mode=mysql';

PREPARE STMT_1 from 'create table t3 (id int, nm varchar(100), age smallint)'
execute stmt_1
PREPARE STMT_2 from 'alter table t3 rename t4'
execute stmt_2
PREPARE STMT_3 from 'insert into t3(id, nm, age) values (1, ?, ?)'
execute stmt_3 using 'hello', 100
DEALLOCATE PREPARE stmt_1
DEALLOCATE PREPARE stmt_2
DEALLOCATE PREPARE stmt_3;
select * from t3;
select * from t4;
drop table t3;
drop table t4;

PREPARE STMT_1 from 'create table t5 (id int, nm varchar(100), age smallint)'
execute stmt_1
PREPARE STMT_2 from 'alter table t5 rename t6'
execute stmt_2
PREPARE STMT_3 from 'insert into t6(id, nm, age) values (1, ?, ?)'
execute stmt_3 using 'hello', 100
DEALLOCATE PREPARE stmt_1
DEALLOCATE PREPARE stmt_2
DEALLOCATE PREPARE stmt_3;
select * from t5;
select * from t6;
drop table t5;
drop table t6;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
