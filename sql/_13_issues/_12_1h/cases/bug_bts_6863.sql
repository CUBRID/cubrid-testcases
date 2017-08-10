--TEST: [Multi-table Delete] Error occurs in multi-table delete when one of the column has the same name with the table it belongs to.


create table a(a int);
create table b(a int);

insert into a values(1), (2), (3);
insert into b values(1), (3), (4);

delete a, b from a, b where a.a=b.a;
delete a, b from a, b;
delete from a, b using a, b;


drop table a, b;



create table a(a int, b int, c int);
create table b(a int, b int, c int);
create table c(a int, b int, c int);

insert into a values(1, 2, 3);
insert into b values(2, 2, 3);
insert into c values(3, 2, 3);


delete b, c from a left outer join b on a.b=b.b inner join c on b.c=c.c;
delete a, b from a, b, c where a.a=b.b and b.b=c.c;
delete b, c from a, b, c;
delete a, b, c from a, b, c;
delete a, b from a, b, c;

select * from a;

drop table a, b, c;
