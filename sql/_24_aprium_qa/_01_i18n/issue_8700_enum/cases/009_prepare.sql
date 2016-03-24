--+ holdcas on;

drop table if exists t1;
create table t1 (i integer, e1 enum('a', 'b', 'c') collate iso88591_bin, e2 enum('d','e') collate utf8_en_cs, e3 enum ('aa', 'bb', 'cc') collate euckr_bin);
show full columns from t1;

insert into t1 values (1, 1, 1, 1), (2, 2, 2, 2);
select * from t1 order by 1, 2, 3, 4;

create table t2 (i integer, num1 integer, num2 short, num3 float);
show full columns from t1;

insert into t2 select * from t1;
select * from t2 order by 1, 2, 3, 4;

prepare stmt1 from 'select * from t1 where e1 = ?';
select @v1:=e2 from t2 where t2.i = 1 order by 1;
execute stmt1 using @v1;
drop prepare stmt1;
drop variable @v1;

prepare stmt1 from 'select * from t1 where e1 = ?';
select @v1:=e3 from t2 where t2.i = 1 order by 1;
execute stmt1 using @v1;
drop prepare stmt1;
drop variable @v1;

prepare stmt2 from 'select * from t1 where e2 = ?';
select @v2:=e1 from t2 where t2.i = 1 order by 1;
execute stmt2 using @v2;
drop prepare stmt2;
drop variable @v2;

prepare stmt2 from 'select * from t1 where e2 = ?';
select @v2:=e3 from t2 where t2.i = 1 order by 1;
execute stmt2 using @v2;
drop prepare stmt2;
drop variable @v2;

prepare stmt3 from 'select * from t1 where e3 = ?';
select @v3:=e1 from t2 where t2.i = 1 order by 1;
execute stmt3 using @v3;
drop prepare stmt3;
drop variable @v3;

prepare stmt3 from 'select * from t1 where e3 = ?';
select @v3:=e2 from t2 where t2.i = 1 order by 1;
execute stmt3 using @v3;
drop prepare stmt3;
drop variable @v3;

drop table t1;
drop table t2;

commit;
--+ holdcas off;
