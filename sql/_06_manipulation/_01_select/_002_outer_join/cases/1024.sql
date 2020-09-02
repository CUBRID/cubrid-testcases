set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
--test   complex select with some select statements which include many joins.

create class DML_0001( 	
int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

create class DML_0002 	(	
int_col int not null,
var_col varchar(20),
set_col set (int, varchar(20)),
ref_col DML_0001,
set_ref_col set of DML_0001);

create class DML_0003 under DML_0001( 	
int_col1 int not null);
insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});
select DML_0001 into a from DML_0001 where int_col = 1;
select DML_0001 into b from DML_0001 where int_col = 2;
select DML_0001 into c from DML_0001 where int_col = 3;
select DML_0001 into d from DML_0001 where int_col = 4;
select DML_0001 into e from DML_0001 where int_col = 5;
insert into DML_0002 values (1, 'test1', {1,'test1'}, a, {a, b, c});
insert into DML_0002 values (2, 'test1', {1,'test1'}, b, {a, b, d});
insert into DML_0002 values (3, 'test2', {1,'test2'}, c, {a, b, e});
insert into DML_0002 values (4, 'test1', {2,'test1'}, d, {b, c, d});
insert into DML_0002 values (5, 'test2', {2,'test2'}, e, {b, c, e});
insert into DML_0003 values (1,'test1', {1,'test1'},1);
insert into DML_0003 values (2,'test1', {1,'test1'},2);
insert into DML_0003 values (3,'test2', {1,'test2'},3);
insert into DML_0003 values (4,'test1', {2,'test1'},4);
insert into DML_0003 values (5,'test2', {2,'test2'},5);
select int_col, var_col, ref_col.int_col from DML_0002 
where int_col > 1 and var_col like '%test%' and set_col superset {2}
order by 1,var_col,ref_col.int_col;

select DML_0001.int_col,DML_0002.ref_col.int_col from DML_0001,DML_0002
where DML_0001.int_col = DML_0002.int_col and dml_0001.var_col like '%test%' and 
dml_0002.int_col between 1 and 4
and dml_0001.set_col superseteq {1}
order by 1,2;

select DML_0001.int_col,DML_0002.ref_col.int_col from all DML_0001,DML_0002
where DML_0001.int_col = DML_0002.int_col
group by DML_0001.int_col, DML_0002.ref_col.int_col
order by 1,2;

select int_col, var_col, ref_col.int_col, a.int_col from DML_0002 as b, table(b.set_ref_col) as t(a)
where int_col between 1 and 4 and ref_col.int_col between 1 and 4 and a.int_col between 1 and 4
order by 1,2,3,4;

select a.int_col, b.var_col, b.ref_col.int_col, max(c.int_col)
from DML_0001 a, DML_0002 b left outer join DML_0003 c on b.int_col=c.int_col and b.var_col like '%test%' 
and b.int_col between 1 and 4
where a.int_col = b.int_col and c.set_col superseteq {1}
group by a.int_col, b.var_col, b.ref_col.int_col
order by 1,2,3;

select int_col, var_col, ref_col.int_col, a.int_col from DML_0002 b left outer join table(b.set_ref_col) as t(a)
on b.ref_col = a and b.var_col like '%test%'
where int_col between 1 and 4 and ref_col.int_col between 1 and 4 and a.int_col between 1 and 4
order by 1,2,3,4;


drop class DML_0001;
drop class DML_0002;
drop class DML_0003;
drop variable a,b,c,d,e ;

--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
