--[er]test all, EXCEPT operator using a select statement which have the operator 'all','EXCEPT' 

create class DML_0001
( 	int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

create class DML_0002
(	int_col int not null,
var_col varchar(20),
set_col set (int, varchar(20)),
ref_col DML_0001,
set_ref_col set of DML_0001);

create class DML_0003 under DML_0001
( 	int_col1 int not null);

create class DML_0004 under DML_0003
( 	int_col2 int not null);

create class DML_0005 under DML_0004
( 	int_col3 int not null);
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
insert into DML_0004 values (1,'test1', {1,'test1'},1,1);
insert into DML_0004 values (2,'test1', {1,'test1'},2,2);
insert into DML_0004 values (3,'test2', {1,'test2'},3,3);
insert into DML_0004 values (4,'test1', {2,'test1'},4,4);
insert into DML_0004 values (5,'test2', {2,'test2'},5,5);
insert into DML_0005 values (1,'test1', {1,'test1'},1,1,1);
insert into DML_0005 values (2,'test1', {1,'test1'},2,2,2);
insert into DML_0005 values (3,'test2', {1,'test2'},3,3,3);
insert into DML_0005 values (4,'test1', {2,'test1'},4,4,4);
insert into DML_0005 values (5,'test2', {2,'test2'},5,5,5);

select * from all DML_0001 (EXCEPT DML_0002) order by 1;



drop class DML_0001;
drop class DML_0002;
drop class DML_0003;
drop class DML_0004;
drop class DML_0005;
