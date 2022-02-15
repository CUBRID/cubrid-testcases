--+ holdcas on;
set system parameters 'compat_mode=mysql';

CREATE TABLE t1 (id int AUTO_INCREMENT primary key, b int);
insert into t1(id, b) values (null, 1);
insert into t1(id, b) values (3, 2);
insert into t1(id, b) values (null, 3);
insert into t1(id, b) values (null, 4);
select * from t1 order by b asc;
drop table t1;


PREPARE stmt from 'CREATE TABLE t1 (id int AUTO_INCREMENT primary key, b int)';
execute stmt;
PREPARE stmt from 'insert into t1(id, b) values (null, 1),(null, 2),(null, 3),(null, 4),(null, 5)';
execute stmt;
PREPARE stmt from 'delete from t1 where id>=3';
execute stmt;
PREPARE stmt from 'insert into t1(id, b) values (null, 6),(null, 7)';
execute stmt;
PREPARE stmt from 'select * from t1 order by b asc';
execute stmt;
DEALLOCATE PREPARE stmt;
drop table t1;

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
