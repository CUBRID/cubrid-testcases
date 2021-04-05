--+ holdcas on;
-- misc tests for query plan dump & order by combined with group by
create class xoo ( a int not null, b char(5), c varchar(5));

create index i_ab on xoo(a, b);
create index i_c on xoo(a, b);

insert into xoo values(1, '9','8'), (4, '8','8'), (3, '7','8'), (1, '2','8'), (1, '4','7'), (1, '4','3'), (1, '4','1'), (1, '4','7'), (9, '2','8'), (7, '2','9'), (2, '3','8'), (5, '5','0'), (6, '8','8'), (8, '9','3'), (8, '9','2');

select * from xoo group by a, b;
select * from xoo group by a desc, b desc;
select * from xoo group by a order by b;
select a, b, group_concat(b) from xoo group by a, b;
select * from xoo where c > 0 group by c order by a, b;
select count(*), c from xoo where c > 0 group by c;

drop class xoo;


create class xoo2 ( a int, b char(5), c varchar(5));

create index i_abc on xoo2(a, b, c);
insert into xoo2 values(1, '9','8'), (4, '8','8'), (3, '7','8'), (1, '2','8'), (1, '4','7'), (1, '4','3'), (1, '4','1'), (1, '4','7'), (9, '2','8'), (7, '2','9'), (2, '3','8'), (5, '5','0'), (6, '8','8'), (8, '9','3'), (8, '9','2'), (null, null, 'a'), (null, '1', 'a'), (null, '2', 'a'), (null, '2', 'b'), (null, '3', 'b');

-- first column not null
select * from xoo2 group by a, b;
select * from xoo2 group by a desc, b desc;
select * from xoo2 group by a order by b;

-- term with first column
select * from xoo2 where a > 0 group by a, b;
select * from xoo2 where a > 0 group by a desc, b desc;

-- term with first column is not null
select * from xoo2 where a is not null group by a, b;
select * from xoo2 where a is not null group by a desc, b desc;

drop class xoo2;


create class xoo3 (a int, b int, c int, d int, e int);
insert into xoo3 values(1, 2, 3, 4, 5), (1, 2, 3, 4, 6), (1, 2, 3, 5, 6), (1, 2, 4, 5, 6), (1, 3, 4, 5, 6), (2, 3, 4, 5, 6);
create index i_abcd on xoo3(a, b, c, d);

select * from xoo3 group by a, b, c, d;
select * from xoo3 where a > 0 group by a, b, c, d;
select * from xoo3 where a > 0 group by a, b;
select * from xoo3 where a > 0 and b = 3 and c = 4 group by a, d;
select min(a) from xoo3 where a > 0 group by a, b;
select max(d) from xoo3 where a > 0 group by a, b;
select sum(a*b*c*d*e) from xoo3 where a > 0 group by a, b, c, d;
select sum(a*b*c*d*e) from xoo3 group by a, b, c, d;
select sum(a*b*c*d*e) from xoo3 where a > 0 group by a, b, c, d;
select sum(a*b*c*d*e) from xoo3 group by a, b, c, d;
select sum(a+b+c), e from xoo3 group by b, c, d;

drop class xoo3;
--+ holdcas off;
