-- create a class with korean name


create class 찾기  
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );

insert into 찾기 values (1,'test1', {1,'test1'});
insert into 찾기 values (2,'test1', {1,'test1'});
insert into 찾기 values (3,'test2', {1,'test2'});
insert into 찾기 values (4,'test1', {2,'test1'});
insert into 찾기 values (5,'test2', {2,'test2'});

select * from 찾기;



drop class 찾기;
