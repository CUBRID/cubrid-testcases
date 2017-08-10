--test class name, alias using select queries.

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

create class DML_0003 under DML_0001( 	int_col1 int not null);

insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});
select DML_0001 into a from DML_0001 where int_col = 1 order by 1;
select DML_0001 into b from DML_0001 where int_col = 2 order by 1;
select DML_0001 into c from DML_0001 where int_col = 3 order by 1;
select DML_0001 into d from DML_0001 where int_col = 4 order by 1;
select DML_0001 into e from DML_0001 where int_col = 5 order by 1;
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
select int_col, var_col, ref_col.int_col from DML_0002 order by 1,2,3;
select DML_0001.int_col,DML_0002.ref_col.int_col from DML_0001,DML_0002 order by 1,2;
select DML_0001.int_col, b.int_col from DML_0001, DML_0002 b  order by 1,2;
select a.int_col,b.ref_col.int_col from all DML_0001 as a,DML_0002 as b  order by 1,2;
select int_col, var_col, ref_col.int_col, a.int_col from DML_0002 as b, table(b.set_ref_col) as t(a)  order by 1,2,3,4;
select count(*) from DML_0001 a, DML_0001 b,DML_0001 c,DML_0001 d,DML_0001 e,DML_0001 f,DML_0001 g order by 1;



drop class DML_0001;
drop class DML_0002;
drop class DML_0003;
