drop if exists t;
create table t(i int primary key, name varchar(20),job varchar(20));
insert into t values(1,'Jone','teacher');
insert into t values(2,'Chandel','programmer');
insert into t values(3,'Jim',null);
insert into t select rownum+3,'person'||rownum,'unkown' from db_root connect by level <=20;
create index idx_t_job on t(job);

--expr:unsign int
delete from t where job='unkown' using index idx_t_job keylimit 0,3 ;
delete from t where job='unkown' using index idx_t_job keylimit 4,3 ;
delete from t where job='unkown' using index idx_t_job keylimit 4,5 ;
delete from t where job='unkown' using index idx_t_job keylimit 0 ;
delete from t where job='unkown' using index idx_t_job keylimit 1;
delete from t where job='unkown' using index idx_t_job keylimit 5 ;
delete from t where job='unkown' using index idx_t_job keylimit 1000;


--expr: unsign int+unsign int
insert into t select rownum+3,'person'||rownum,'unkown' from db_root connect by level <=20;
delete from t where job='unkown' using index idx_t_job keylimit 0+2,3;
delete from t where job='unkown' using index idx_t_job keylimit 4+0,3 ;
delete from t where job='unkown' using index idx_t_job keylimit 4+2,3 ;
delete from t where job='unkown' using index idx_t_job keylimit 4+1000,3 ;
delete from t where job='unkown' using index idx_t_job keylimit 0+1 ;
delete from t where job='unkown' using index idx_t_job keylimit 0+1000 ;
insert into t select rownum+3000,'person'||rownum,'unkown' from db_root connect by level <=20;
delete from t where job='unkown' using index idx_t_job keylimit 0+2,3+1;
delete from t where job='unkown' using index idx_t_job keylimit 4+0,3 +0;
delete from t where job='unkown' using index idx_t_job keylimit 4+0,3 +1000;
delete from t where job='unkown' using index idx_t_job keylimit 3 +1000;
--expr: unsign int-unsign int
insert into t select rownum+4000,'person'||rownum,'unkown' from db_root connect by level <=20;
delete from t where job='unkown' using index idx_t_job keylimit 0-2,3;
delete from t where job='unkown' using index idx_t_job keylimit 4-0,3 ;
delete from t where job='unkown' using index idx_t_job keylimit 4-2,3 ;
delete from t where job='unkown' using index idx_t_job keylimit 4-1000,3 ;
delete from t where job='unkown' using index idx_t_job keylimit 0,40/2 ;
insert into t select rownum+5000,'person'||rownum,'unkown' from db_root connect by level <=20;
delete from t where job='unkown' using index idx_t_job keylimit 0-1 ;
delete from t where job='unkown' using index idx_t_job keylimit 0-1000 ;
delete from t where job='unkown' using index idx_t_job keylimit 0-2,3-1;
delete from t where job='unkown' using index idx_t_job keylimit 4-0,3 -0;
delete from t where job='unkown' using index idx_t_job keylimit 4-0,3 -1000;


--nvl
set @a=3;
delete from t where job='unkown' using index idx_t_job keylimit @a,3;
delete from t where job='unkown' using index idx_t_job keylimit nvl(null,0),3 ;
delete from t where job='unkown' using index idx_t_job keylimit nvl(null,1),3 ;
drop if exists t;
drop variable @a;
