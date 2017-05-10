drop if exists t;
create table t(i int primary key, name varchar(100),job varchar(20));
insert into t values(1,'Jone','teacher');
insert into t values(2,'Chandel','programmer');
insert into t values(3,'Jim',null);
insert into t select rownum+3,'person'||rownum,'unkown' from db_root connect by level <=10;
create index idx_t_job on t(job);

--expr:unsign int
update t set name=name||'update1' where job='unkown' using index pk_t_i keylimit 0,3 ;
select * from t order by 1;
update t set name=name||'update2' using index pk_t_i keylimit 0,3 ;
select * from t order by 1;
update t set name=name||'update3' where i >5 using index pk_t_i keylimit 0,3 ;
select * from t order by 1;
update t set name=name||'update4' where i >3 using index pk_t_i keylimit 1*3*1*1,3*2;
select * from t order by 1;  
update t set name=name||'update5' where i >5 using index pk_t_i keylimit 0,3 ;
select * from t order by 1;
update t set name=name||'update6' where i >3 using index pk_t_i keylimit 1*3*1*1-1,3*2-1 ; 
select * from t order by 1;
update t set name=name||'update7' where i >3 using index pk_t_i keylimit 20*1024*1024/(8*1024)/(8*1024/(100*2));
select * from t order by 1;
update t set name=name||'update8' where i >3 using index pk_t_i keylimit (9-1)*3+3 ;
select * from t order by 1;
drop if exists t;
