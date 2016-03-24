--TEST: [Multi-table Delete] Result is incorrect when deleting from 2 tables with inner join.
autocommit off;


create table foo(a int);
insert into foo(a) values(1), (2), (3);

create table aoo(c bigint);
insert into aoo values(3), (2);

select * from foo f, aoo a where f.a=a.c order by f.a;

delete f, a from foo f, aoo a where f.a=a.c;

select if (count(*)=1, 'ok', 'nok') from foo;
select if (count(*)=0, 'ok', 'nok') from aoo;


drop table foo;

rollback;

create table a(a int, b int);
create table b(b int, a int);

insert into a values(1, 1);
insert into a values(2, 2);
insert into a values(3, 3);
insert into a values(3, 3);

insert into b values(2, 2);
insert into b values(2, 2);
insert into b values(3, 3);

commit;


select * from a inner join b on a.a=b.a order by a.a;
delete a, b from a inner join b on a.a=b.a;
select if (count(*)=1, 'ok', 'nok') from a;
select if (count(*)=0, 'ok', 'nok') from b;
rollback;

select * from a a left outer join b b on a.b=b.b order by a.b;
delete from a, b using a a left outer join b b on a.b=b.b;
select if (count(*)=0, 'ok', 'nok') from a;
select if (count(*)=0, 'ok', 'nok') from b;
rollback;

select * from a b right outer join b a on b.a=a.b order by a.a;
delete a, b from a b right outer join b a on b.a=a.b;
select if (count(*)=1, 'ok', 'nok') from a;
select if (count(*)=0, 'ok', 'nok') from b;
rollback;

--[er]
select * from a b inner join b on b.a=b.b order by b.a;
delete from b, b using a b inner join b on b.a=b.b;
select if (count(*)=4, 'ok', 'nok') from a;
select if (count(*)=3, 'ok', 'nok') from b;
rollback;

--[er]
select * from a, b a where a.a=a.a order by b.b;
delete a from a, b a where a.a=a.a;
select if (count(*)=4, 'ok', 'nok') from a;
select if (count(*)=3, 'ok', 'nok') from b;
rollback;


drop table a, b;
commit;



create table a(a int, b int);
create table b(b int, a int);

insert into a values(1, 2);
insert into a values(2, 1);
insert into a values(3, 2);
insert into a values(3, 3);

insert into b values(2, 3);
insert into b values(2, 2);
insert into b values(3, 3);

commit;


select * from a inner join b on a.a=b.a order by a.a,b.b;
delete a, b from a inner join b on a.a=b.a;
select if (count(*)=1, 'ok', 'nok') from a;
select if (count(*)=0, 'ok', 'nok') from b;
rollback;

select * from a a left outer join b b on a.b=b.b order by a.b,b.a;
delete from a, b using a a left outer join b b on a.b=b.b;
select if (count(*)=0, 'ok', 'nok') from a;
select if (count(*)=0, 'ok', 'nok') from b;
rollback;

select * from a b right outer join b a on b.a=a.b order by a.a;
delete a, b from a b right outer join b a on b.a=a.b;
select if (count(*)=1, 'ok', 'nok') from a;
select if (count(*)=0, 'ok', 'nok') from b;
rollback;

--[er]
select * from a b inner join b on b.a=b.b order by b.a;
delete from b, b using a b inner join b on b.a=b.b;
select if (count(*)=4, 'ok', 'nok') from a;
select if (count(*)=3, 'ok', 'nok') from b;
rollback;

--[er]
select * from a, b a where a.a=a.a order by b.b;
delete a from a, b a where a.a=a.a;
select if (count(*)=4, 'ok', 'nok') from a;
select if (count(*)=3, 'ok', 'nok') from b;
rollback;


drop table a, b;
commit;



autocommit on;
