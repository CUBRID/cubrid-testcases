drop table if exists ordby_nulls;
prepare stm from 'select 1 from db_root';
execute stm;
deallocate prepare stm;

prepare stm from 'select 1+? from db_root';
execute stm using 2;
deallocate prepare stm;

prepare stm from 'select 1*?*? from db_root';
execute stm using '2',3;
deallocate prepare stm;

prepare stm from 'select ? from db_root'
execute stm using 2
deallocate prepare stm;

prepare stm from 'select ? from db_root'
execute stm using '2'
deallocate prepare stm;

prepare stm from 'select ? from db_root'
execute stm using 'a'
deallocate prepare stm;

prepare stm from 'select ? from db_root'
execute stm using null
deallocate prepare stm;

prepare my_show_tables from 'select class_name, owner_name from db_class where is_system_class != ''YES'' order by class_name';
prepare my_show_columns from 'select attr_name, data_type from db_attribute where lower(class_name) = lower (?) order by attr_name';

prepare stmt from 'create table t (i int, s varchar(255))';
execute stmt;
deallocate prepare stmt;

execute my_show_tables;
execute my_show_columns using 't';

prepare stmt from 'insert into t values(?,?)';
execute stmt using 1, '1';
execute stmt using 2, '2';
execute stmt using 3, '3';
execute stmt using 4, '4';
execute stmt using 5, '5';

execute stmt using 1;

deallocate prepare stmt;

prepare stmt from 'select * from t where i > ? order by 1, 2';
execute stmt using 1;
execute stmt using 2;

prepare upd from 'update t set i = ? where i = ?';
execute upd using 10, 1;
execute upd using 20, 2;

execute stmt using 1;
execute stmt using 2;

deallocate prepare upd;
deallocate prepare stmt;

execute my_show_columns using 't';

prepare stmt from 'alter table t change s s double';
execute stmt;
deallocate prepare stmt;

execute my_show_columns using 't';

prepare stmt from 'create table u as select i*? as i, s as d from t where i > ?';
execute stmt using 100, 2;

execute my_show_tables;
execute my_show_columns using 'u';

execute stmt using 3;
deallocate prepare stmt;


prepare stmt from 'select u.i, u.d as s from u where d<? union select t.i, t.s from t where i > ? order by 1, 2';
execute stmt using 10, 3;
deallocate prepare stmt;

deallocate prepare stmt;

prepare stmt from 'create trigger trig_t before insert on t execute insert into u values(new.i, new.s)';
execute stmt;
deallocate prepare stmt;

prepare stmt from 'truncate table t';
execute stmt;

truncate table u;

prepare stmt from 'insert into t values(?,?)';
execute stmt using 1, 1;
execute stmt using 2, 2;
execute stmt using 3, 3;
execute stmt using 4, 4;

deallocate prepare stmt;

select * from t order by 1,2;
select * from u order by 1,2;

prepare stmt from 'select * from u order by i';

prepare drp from 'drop table u';
execute drp;

execute stmt;
deallocate prepare stmt;

execute my_show_tables;

execute drp;
deallocate prepare drp;

prepare stmt from 'drop trigger trig_t';
execute stmt;
deallocate prepare stmt;

prepare stmt from 'drop table t';
execute stmt;
deallocate prepare stmt;


deallocate prepare my_show_tables;
deallocate prepare my_show_columns;
