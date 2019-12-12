-- [er]add attribute of default when date of table exist
create class c_nc (it int);

insert into c_nc values (2);
alter class  c_nc add attribute nc string DEFAULT 'a';
insert into c_nc values (2);

insert into c_nc values (2,'sadf');

select * from c_nc;

drop class c_nc;