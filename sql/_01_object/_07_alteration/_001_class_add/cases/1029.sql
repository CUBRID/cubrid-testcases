-- add attribute of not null when date of table not exist
create class c_nc (it int);

insert into c_nc values (2);

alter class  c_nc add attribute nc String not null;

select * from c_nc;
drop class c_nc;