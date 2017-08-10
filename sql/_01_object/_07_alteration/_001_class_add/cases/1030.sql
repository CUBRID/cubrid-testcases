-- add attribute of Shared when date of table exist
create class c_nc (it int);

insert into c_nc values (2);
alter class  c_nc add attribute nc string Shared 'a';

select * from c_nc;

drop class c_nc;