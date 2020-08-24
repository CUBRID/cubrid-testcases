set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
create class DML_0001
( int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );

insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

select int_col, var_col from dml_0001 group by int_col, var_col order by 1;
select int_col, var_col from dml_0001 group by 1, 2 order by 1;

drop table dml_0001;



create table x (i int, s varchar(32));
insert into x values(1, 'a');
insert into x values(2, 'a');
insert into x values(1, 'b');
insert into x values(2, 'c');
insert into x values(3, 'b');

-- Each two statements should return the same result.
select i from x group by i order by 1;
select i from x group by 1 order by 1;

select s from x group by s order by 1;
select s from x group by 1 order by 1;

select group_concat(i order by i), s from x group by s order by s;
select group_concat(i order by i), s from x group by 2 order by 2;

select i, group_concat(s order by s) from x group by i order by i;
select i, group_concat(s order by s) from x group by 1 order by 1;

select i + 1, group_concat(s order by s) from x group by i + 1 order by 1;
select i + 1, group_concat(s order by s) from x group by 1 order by 1;

select sum(i + 1), concat(s, 'xxx') from x group by concat(s, 'xxx') order by 2;
select sum(i + 1), concat(s, 'xxx') from x group by 2 order by 2;

select i, s from x group by s, i order by s,i;
select i, s from x group by s, 1 order by s,1;


select i,s from x group by 1,2 order by 1,2;
select x.i, x.s from x x group by x.i, x.s order by 1,2;
select i,s from x group by s,1 order by s,1;
select x.i, x.s from x x group by x.s, x.i order by 2,1;


select sum(i), (select s from x where i=1 order by i,s limit 1) from x group by 2;


drop table x;





create table y (i int);
create table z (i int, j y);
insert into y values(1) to :obj1;
insert into y values(2) to :obj2;
insert into z values(10, :obj1);
insert into z values(10, :obj2);
insert into z values(20, :obj1);

-- The following two statements should return the same result.
select /*+ recompile */ sum(i), z.j.i from z group by z.j.i order by 2;
select /*+ recompile */ sum(i), z.j.i from z group by 2 order by 2;

drop table y,z;
commit;
--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
