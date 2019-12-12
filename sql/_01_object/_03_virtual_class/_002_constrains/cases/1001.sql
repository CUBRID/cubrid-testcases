-- tests a create view syntax using select with condition

create class dml_0001 ( a int, b varchar(10));
create view vdml_0001 ( a,b )
as select a, b from dml_0001
where   a =1 and  (b not like '99%' or b='999');

insert into dml_0001 values ( 1, '991' );
insert into dml_0001 values ( 1, '992' );
insert into dml_0001 values ( 1, '993' );
insert into dml_0001 values ( 1, '994' );
insert into dml_0001 values ( 1, '995' );
insert into dml_0001 values ( 1, '999' );
insert into dml_0001 values ( 1, '919' );





select * from vdml_0001 where b='993';
select * from vdml_0001 where b like '9%';


drop class dml_0001;
drop view vdml_0001;