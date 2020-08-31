--[er]Test user defined domain type using incompatible data type 
set system parameters 'create_table_reuseoid=no';

create class x1 ( i int);
create class x2 ( i int);
create class x3 ( i int, j x1);
insert into x1 values(1);
insert into x2 values(1);
insert into x3 values(1, null);

insert into x3 values(2, insert into x2 values(2));

update x3 set j = ( select x2 from x2 where i = 1) where i = 1;
delete from x3 where j =  ( select x2 from x2 where rownum = 1);
drop x1;
drop x2;
drop x3;

set system parameters 'create_table_reuseoid=yes';
