--+ holdcas on;
--[er]concatenate two data with || operator, and each one is bracketed by "" 
create class DML_0001 
( 	int_col integer,
var_col varchar(20),
set_col set (int, varchar(10)) );

insert into DML_0001 values (1,'test1', {1,'test1'});
insert into DML_0001 values (2,'test1', {1,'test1'});
insert into DML_0001 values (3,'test2', {1,'test2'});
insert into DML_0001 values (4,'test1', {2,'test1'});
insert into DML_0001 values (5,'test2', {2,'test2'});

select 123, int_col, "123" || "test1" from dml_0001 order by 1,2;
set system parameters 'compat_mode=mysql';
select 123, int_col, concat("123", "test1") from dml_0001 order by 1,2;
set system parameters 'compat_mode=cubrid';

drop class DML_0001;
commit;
--+ holdcas off;
