--asc/desc index test
create class xoo ( a int, b char(5), c varchar(5));
create index idx1 on xoo(a desc, b asc, c desc);

insert into xoo values(1, '9','8');
insert into xoo values(4, '8','8');
insert into xoo values(3, '7','8');
insert into xoo values(1, '2','8');
insert into xoo values(1, '4','7');
insert into xoo values(1, '4','3');
insert into xoo values(1, '4','1');
insert into xoo values(1, '4','7');
insert into xoo values(9, '2','8');
insert into xoo values(7, '2','9');
insert into xoo values(2, '3','8');
insert into xoo values(5, '5','0');
insert into xoo values(6, '8','8');
insert into xoo values(8, '9','3');
insert into xoo values(8, '9','2');

select * from xoo where a > 4   or a > 6 order by a asc, 2,3;
select * from xoo where a > 4   or a > 6 order by a desc, 2,3;
select * from xoo where a in( 4,5,6) and a > 5 order by a desc2,3;
select * from xoo where a not in( 4,5,6) order by a desc, 2,3;

select * from xoo xoo where (a not in set{4, 5, 6}) and (a>5) order by 1,2,3;
select * from xoo where ( a not between 1 and 5) and a > 1 order by a desc, 2,3;
select * from xoo where ( a not between 5 and 8) or a > 7 order by a desc, 2,3;
select * from xoo where ( a < 3 and a > 6) or a > 7 order by a desc, 2,3;

select * from xoo where a not in( 4,5,6) and a > 5 order by a desc, 2,3;
select * from xoo where a not in( 4,5,6) and a > 5 order by a asc, 2,3; 
 

select * from xoo where a = 3 order by 1, 2,3;
select * from xoo where a = 3 order by  a, 2,3;
select * from xoo where a = 3 order by  a, 2,3;

select * from xoo where a > 4  order by a , 2,3;
select * from xoo where a > 4  order by a desc, 2,3;
select * from xoo where a > 4  order by a ascv

select * from xoo where a = 1 order by a , 2,3;
select * from xoo where a = 1 order by  a, 2,3;
select * from xoo where a = 1 order by  a, 2,3;

select * from xoo where a = 1 order by a desc, b asc;
select * from xoo where a = 1 order by a desc, b desc;


select * from xoo where a = 1 and b > '0' order by a desc, b asc;
select * from xoo where a = 1 and b > '3' order by a desc, b desc;
select * from xoo where a = 1 and b > '0' order by a desc, b ;
select * from xoo where a = 1 and b > '3' order by a , b desc;

select * from xoo where a in ( 3,4,5) and  b > '0' order by a,b;

drop xoo;

create class xoo ( a int, b char(5), c varchar(5));
create index idx2 on xoo(a , a , c );

insert into xoo values(1, '9','8');
insert into xoo values(4, '8','8');
insert into xoo values(3, '7','8');
insert into xoo values(1, '2','8');
insert into xoo values(1, '4','7');
insert into xoo values(1, '4','3');
insert into xoo values(1, '4','1');
insert into xoo values(1, '4','7');
insert into xoo values(9, '2','8');
insert into xoo values(7, '2','9');
insert into xoo values(2, '3','8');
insert into xoo values(5, '5','0');
insert into xoo values(6, '8','8');
insert into xoo values(8, '9','3');
insert into xoo values(8, '9','2');

select xoo.a, xoo.b, xoo.c from xoo xoo where (xoo.b>'3') and xoo.a=1 order by 1,2,3;


create class yoo ( a int, b char(5), c varchar(5));
create index idx2 on yoo(a , b , c );

insert into yoo values(1, '9','8');
insert into yoo values(4, '8','8');
insert into yoo values(3, '7','8');
insert into yoo values(1, '2','8');
insert into yoo values(1, '4','7');
insert into yoo values(1, '4','3');
insert into yoo values(1, '4','1');
insert into yoo values(1, '4','7');
insert into yoo values(9, '2','8');
insert into yoo values(7, '2','9');
insert into yoo values(2, '3','8');
insert into yoo values(5, '5','0');
insert into yoo values(6, '8','8');
insert into yoo values(8, '9','3');
insert into yoo values(8, '9','2');


select x.a, y.a 
from yoo y, xoo x 
where y.a > 4 and x.a > 4 and x.a = y.a 
order by x.a desc;

select x.a, y.a
from yoo y, xoo x
where x.a > 4 and x.a = y.a
order by x.a desc;

select x.a, y.a
from yoo y, xoo x
where x.a > 4 and x.a = y.a
order by x.a desc, x.b asc;

select x.a, y.a
from yoo y, xoo x
where x.a = 4 and x.b > '1' and x.a = y.a
order by x.a desc, x.b asc;

select x.a, x.b
from yoo y, xoo x
where x.b > '5' and x.a = y.a
order by x.a desc, x.b asc;

drop xoo;
drop yoo;
