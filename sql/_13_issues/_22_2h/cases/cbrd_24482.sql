drop if exists t;
create table t(id int, val int);
insert into t values(1,1), (2,2),(3,3),(4,4);
create index idx1r on t (mod(id,3), id);
select 1 from t where mod(id, 3)=0 and id > 1 using index idx1r;
drop if exists t;
