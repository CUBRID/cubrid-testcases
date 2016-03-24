--test for binding when running dynamic query

create class xoo ( a int, b string);

insert into xoo values(1,'1');
insert into xoo values(2,'2');
insert into xoo values(3,'3');
insert into xoo values(4,'4');
insert into xoo values(5,'5');

select a,b from xoo  order by a asc, b desc ;
select a,b from xoo  order by a asc, b desc for orderby_num() > 1 and orderby_num() <= 2 + 2;
$int, $1, $int, $2, $int, $2;
select a,b from xoo  order by a asc, b desc for orderby_num() > ? and orderby_num() <= ? + ?;

$int, $1, $int, $2, $int, $2;
select a,b from xoo  where a < 10 order by a asc, b desc for orderby_num() > ? and orderby_num() <= ? + ?;

drop xoo;
