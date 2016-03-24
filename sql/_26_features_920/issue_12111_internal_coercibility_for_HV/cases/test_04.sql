create table t1(id int, a char(10) collate utf8_en_cs, b char(10) collate utf8_en_ci);
insert into t1 values (1, 'Y', 'Y');
insert into t1 values (2, 'y', 'y');
prepare stmt from 'select id, a, ? > a, ? > b from t1 order by id';
execute stmt using 'Z', 'Z';
execute stmt using 'z', 'z';
execute stmt using 'X', 'X';
execute stmt using 'x', 'x';
deallocate prepare stmt;
drop table t1;

create table t1(id int, a char(10) collate utf8_en_cs, b char(10) collate utf8_en_ci);
insert into t1 values (1, 'Y', 'Y');
insert into t1 values (2, 'y', 'y');
prepare stmt from 'select count(*) from t1 group by a||?';
execute stmt using '';
deallocate prepare stmt;
prepare stmt from 'select count(*) from t1 group by b||?';
execute stmt using '';
deallocate prepare stmt;
drop table t1;


create table t1(id int, a char(10) collate utf8_en_cs, b char(10) collate utf8_en_ci);
insert into t1 values (1, 'YY', 'YY');
insert into t1 values (2, 'yy', 'yy');
prepare stmt from 'select * from t1 where a like ''Y''||? ';
execute stmt using 'y%';
execute stmt using 'Y%';
deallocate prepare stmt;
prepare stmt from 'select * from t1 where b like ''Y''||? ';
execute stmt using 'y%';
execute stmt using 'Y%';
deallocate prepare stmt;
drop table t1;

set names iso88591;