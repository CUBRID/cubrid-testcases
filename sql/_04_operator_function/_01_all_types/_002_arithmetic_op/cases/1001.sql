--test constant in select list 
create class DML_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );

insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

select 'test1', 120 , int_col from DML_0001 order by 1,2,3;
select 'test1' + 'test2', set_col, int_col + 100 from DML_0001 order by 1,2,3;
select '300', int_col from DML_0001 order by 1,2;
select 'var_col', var_col from DML_0001 order by 1,2;
select 190+10*2 from DML_0001 order by 1;


drop class DML_0001;
