--TEST: [Merge Statement] result is not correct after merged


autocommit off;

drop table if exists z1, z2, z3;

create table z1(a int, b int);
create table z2(a int, b int);
insert into z1 values (1, 0);
insert into z1 values (2, 2);
insert into z2 values (1, 1);
insert into z2 values (3, 3);

create table z3 as select * from z2;

commit;

merge into z2 using z1 on (z1.a=z2.a)
when matched then 
update set z2.b=(select sum(z1.b) from z3 where z3.b=z1.b+z2.b);

select a,b from z2 order by a,b;
rollback;


merge into z2 using z1 on (z1.a=z2.a)
when not matched then
insert values(100, (select z1.b from z3 where z3.b=z1.b and rownum<1));

select a,b from z2 order by a,b;
rollback;


merge into z2 using z1 on(z1.a=z2.a)
when matched then
update set z2.b=(select b from z3 order by 1 desc limit 1)
delete where (select a from z3 where rownum = 2) < 0;

select a,b from z2 order by a,b;


drop table z1, z2, z3;
commit;


autocommit on;
