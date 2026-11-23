--+ holdcas on;
drop if exists t;
create table t(i int primary key, name varchar(20),job varchar(20));
insert into t values(1,'Jone','teacher');
insert into t values(2,'Chandel','programmer');
insert into t values(3,'Jim',null);
insert into t select rownum+3,'person'||rownum,'unkown' from db_root connect by level <=10;
create index idx_t_job on t(job,i);

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
