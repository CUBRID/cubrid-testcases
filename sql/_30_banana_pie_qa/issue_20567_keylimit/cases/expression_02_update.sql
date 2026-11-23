drop if exists t;
create table t(i int primary key, name varchar(100),job varchar(20));
insert into t values(1,'Jone','teacher');
insert into t values(2,'Chandel','programmer');
insert into t values(3,'Jim',null);
insert into t select rownum+3,'person'||rownum,'unkown' from db_root connect by level <=10;
create index idx_t_job on t(job);

select * from t order by 1;
select * from t order by 1;
select * from t order by 1;
select * from t order by 1;  
select * from t order by 1;
select * from t order by 1;
select * from t order by 1;
select * from t order by 1;
drop if exists t;
