create table x (i int, j int, k int);
insert into x values (1, 1, 1);
insert into x values (1, 2, 2);
insert into x values (1, 3, 3);
insert into x values (2, 1, 1);
insert into x values (2, 2, 2);
insert into x values (3, 1, 1);
insert into x values (3, 2, 2);

-- no extra columns in select list
create view t as select /*+ recompile */ i, j, k, avg(k) over (partition by i order by j) A from x order by 1, 2;
select * from t limit 100;
drop t;

create view t as select /*+ recompile */ i, j, k, avg(k) over (partition by 1 order by 2) A from x order by 1, 2;
select * from t limit 100;
drop t;

-- one extra column in select list
create view t as select /*+ recompile */ i, k, avg(k) over (partition by i order by j) A from x order by 1, 2;
select * from t limit 100;
drop t;

create view t as select /*+ recompile */ i, k, avg(k) over (partition by 1 order by j) A from x order by 1, 2;
select * from t limit 100;
drop t;


create view t as select /*+ recompile */ j, k, avg(k) over (partition by i order by j) A from x order by 1, 2;
select * from t limit 100;
drop t;

create view t as select /*+ recompile */ j, k, avg(k) over (partition by i order by 1) A from x order by 1, 2;
select * from t limit 100;
drop t;

-- two extra columns in select list
create view t as select /*+ recompile */ avg(k) over (partition by i order by j) A from x order by 1;
select * from t limit 100;
drop t;

-- duplicate column, referenced more than once
create view t as select /*+ recompile */ avg(k) over (partition by i order by j asc, j asc, j asc) A from x order by 1;
select * from t limit 100;
drop t;

create view t as select /*+ recompile */ j, j, j, avg(k) over (partition by i order by 1 asc, 2 asc, 3 asc) A from x order by 1, 2;
select * from t limit 100;
drop t;

-- order by direction has priority over partition by direction
create view t as select /*+ recompile */ avg(k) over (partition by i asc order by i desc) A from x order by 1;
select * from t limit 100;
drop t;

create view t as select /*+ recompile */ avg(k) over (partition by i desc order by i asc) A from x order by 1;
select * from t limit 100;
drop t;

create view t as select /*+ recompile */ avg(k) over (partition by i desc, j asc order by i asc, j desc) A from x order by 1;
select * from t limit 100;
drop t;

create view t as select /*+ recompile */ avg(k) over (partition by i asc, i desc order by i asc) A from x order by 1;
select * from t limit 100;
drop t;

-- direction clashes
create view t as select /*+ recompile */ avg(k) over (partition by i order by j asc, j desc) A from x order by 1;
select * from t limit 100;
drop t;

create view t as select /*+ recompile */ j, i, j, avg(k) over (partition by i order by 1 asc, 3 desc) A from x order by 1, 2;
select * from t limit 100;
drop t;

drop x;
