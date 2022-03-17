autocommit off;
create class x (a string);
insert into x values ('abc');
select a, (select a from x where x.a = w.a) from x w;
rollback work;
rollback;
