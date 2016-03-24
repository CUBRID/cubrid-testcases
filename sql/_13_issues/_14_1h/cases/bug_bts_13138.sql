drop if exists t1;
create class t1 ( col1 int, col2 varchar(10));
create trigger tr1 deferred insert on t1 if obj.col1 > 9   execute insert into t1 values (obj.col1 - 5, 'nhn'); 
insert into t1 values(10,'nhnchina');
drop trigger tr1;
drop class t1;

create class t1 ( col1 int, col2 varchar(10));
create trigger tr1 deferred insert on t1 if obj.col1 > 9 execute insert into t1 values (obj.col1 - 5, 'nhn'); 
insert into t1 values(10,'nhnchina');
drop class t1;
