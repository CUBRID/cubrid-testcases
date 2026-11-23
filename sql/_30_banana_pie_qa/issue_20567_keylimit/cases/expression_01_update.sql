drop if exists t;
create table t(i int , name varchar(20),job varchar(20));
insert into t values(1,'Jone','teacher');
insert into t values(2,'Chandel','programmer');
insert into t values(3,'Jim',null);
insert into t select rownum+3,'person'||rownum,'unkown' from db_root connect by level <=20;
create index idx_t_job on t(job);

delete from t;

--expr: unsign int+unsign int
insert into t select rownum+3,'person'||rownum,'unkown' from db_root connect by level <=20;
insert into t select rownum+3000,'person'||rownum,'unkown' from db_root connect by level <=20;
delete from t;
--expr: unsign int-unsign int
insert into t select rownum+4000,'person'||rownum,'unkown' from db_root connect by level <=20;
delete from t;
insert into t select rownum+5000,'person'||rownum,'unkown' from db_root connect by level <=20;
select count(*) from t where job='updated';
drop if exists t;
