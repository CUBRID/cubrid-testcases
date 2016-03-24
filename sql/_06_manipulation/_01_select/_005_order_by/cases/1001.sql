--Test retrieve data using order by


create class xoo ( id int);
insert into xoo values(1);
insert into xoo values(2);
insert into xoo values(3);


select id + 1 as x from xoo order by x;
select to_char(id) as x from xoo order by x;
select id x from xoo order by x;
select id + 1 as x from xoo order by x desc;
select to_char(id) as x from xoo order by x desc;
select id x from xoo order by x desc;
select (select b.id from xoo b where  b.id = a.id) as x from xoo a order by x desc;


drop xoo;
