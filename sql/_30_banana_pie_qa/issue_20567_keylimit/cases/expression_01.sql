--+ holdcas on;
--CBRD-21233
drop table if exists t;
create table t(i int,j int);
insert into t values(1,1);
insert into t values(1,2);
create index idx1 on t(j);
set @a=2;
set @b=1;
set @c=4;
set @d=2;
prepare stmt from 'select * from t where j>=1 limit ?-?,?/?';
execute stmt using @a,@b,@c,@d;
deallocate prepare stmt;
prepare stmt from 'select * from t where j>=1 limit ?,?';
execute stmt using @a,@d;
deallocate prepare stmt;
drop variable @a,@b,@c,@d;
drop if exists t;

--+ holdcas off;
