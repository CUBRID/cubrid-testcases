drop if exists t;
create table t(i int primary key, name varchar(20),job varchar(20));
insert into t values(1,'Jone','teacher');
insert into t values(2,'Chandel','programmer');
insert into t values(3,'Jim',null);
insert into t select rownum+3,'person'||rownum,'unkown' from db_root connect by level <=10;
create index idx_t_job on t(job,i);

--expr:unsign int
select * from t where job='unkown' using index idx_t_job keylimit 0,3 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4,3 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4,5 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 0 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 1 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 5 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 1000 order by 1;

--expr: unsign int+unsign int
select * from t where job='unkown' using index idx_t_job keylimit 0+2,3 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4+0,3 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4+2,3 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4+1000,3 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 0+1 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 0+1000 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 0+2,3+1 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4+0,3 +0 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4+0,3 +1000 order by 1;

--expr: unsign int-unsign int
select * from t where job='unkown' using index idx_t_job keylimit 0-2,3 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4-0,3 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4-2,3 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4-1000,3 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 0-1 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 0-1000 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 0-2,3-1 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4-0,3 -0 order by 1;
select * from t where job='unkown' using index idx_t_job keylimit 4-0,3 -1000 order by 1;


--nvl not support
set @a=3;
select * from t where job='unkown' using index idx_t_job keylimit @a,3;
select * from t where job='unkown' using index idx_t_job keylimit nvl(null,0),3 ;
select * from t where job='unkown' using index idx_t_job keylimit nvl(null,1),3 ;
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
prepare stmt from 'select * from t where j>=1 using index idx1 keylimit ?-?,?/?';
execute stmt using @a,@b,@c,@d;
prepare stmt from 'select * from t where j>=1 limit ?,?';
execute stmt using @a,@d;
deallocate prepare stmt;
drop if exists t;
