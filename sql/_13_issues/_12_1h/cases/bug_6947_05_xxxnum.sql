create table t (i int);
create table u (j int);

-- SELECT
insert into t values (1), (1), (2), (2);
insert into u values (2), (3);

-- inst_num()
create view v as select * from t limit 3;
select * from v order by i;
select * from v, u order by i, j;
select * from u, v order by i, j;
drop v;

create view v as select inst_num() as inum, i from t;
select * from v order by i;
select * from v, u order by i, j;
select * from u, v order by i, j;
drop v;

-- rownum
create view v as select * from t where rownum <= 3;
select * from v order by i;
select * from v, u order by i, j;
select * from u, v order by i, j;
drop v;

create view v as select rownum as rnum, i from t;
select * from v order by i;
select * from v, u order by i, j;
select * from u, v order by i, j;
drop v;

-- cleanup
drop t, u;
