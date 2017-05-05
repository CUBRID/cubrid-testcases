drop if exists t;
create table t(i int , name varchar(20),job varchar(20));
insert into t values(1,'Jone','teacher');
insert into t values(2,'Chandel','programmer');
insert into t values(3,'Jim',null);
insert into t select rownum+3,'person'||rownum,'unkown' from db_root connect by level <=10;
create index idx_t_job on t(job);

drop if exists x;
create table x(i int, name varchar(20),job varchar(20));
create index idx_x_job on x(job);
--expr:unsign int
insert into x select * from t where job='unkown' using index idx_t_job keylimit 0,3 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4,3 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4,5 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 0 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 1;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 5 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 1000;
select * from x order by 1;

--expr: unsign int+unsign int
insert into x select * from t where job='unkown' using index idx_t_job keylimit 0+2,3;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4+0,3 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4+2,3 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4+1000,3 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 0+1 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 0+1000 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 0+2,3+1;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4+0,3 +0;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4+0,3 +1000;
select * from x order by 1;

--expr: unsign int-unsign int
insert into x select * from t where job='unkown' using index idx_t_job keylimit 0-2,3;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4-0,3 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4-2,3 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4-1000,3 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 0-1 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 0-1000 ;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 0-2,3-1;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4-0,3 -0;
select * from x order by 1;
insert into x select * from t where job='unkown' using index idx_t_job keylimit 4-0,3 -1000;
select * from x order by 1;
select count(*) from x;
drop if exists t,x;
