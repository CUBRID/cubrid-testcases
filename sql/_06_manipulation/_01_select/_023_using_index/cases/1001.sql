--  tests  select statement which includes a number of 'or' keyword

create class xoo ( id int);
insert into xoo values(1);
insert into xoo values(2);
insert into xoo values(3);
insert into xoo values(4);
insert into xoo values(5);
insert into xoo values(6);
insert into xoo values(7);
insert into xoo values(8);
insert into xoo values(9);
insert into xoo values(10);
insert into xoo select id+10 from xoo;
create index i_xoo_id  on xoo (id);


select  id from xoo
where
   (id between 1 and 5)
   or (id between 7 and 9)
   or (id > 4 and id < 10)
using index i_xoo_id(+) order by 1;


select  id from xoo
where
   (id between 1 and 5)
   or (id > 4 and id < 10)
   or (id between 7 and 9)
using index i_xoo_id(+) order by 1;


drop xoo;
