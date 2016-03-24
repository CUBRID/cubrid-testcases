--bind parameters in where clause

create class xoo ( a int );
insert into xoo values(1);
insert into xoo values(2);
$int, $2;
insert into xoo select ? + a from xoo;

$int, $3, $int, $2, $int, $1;
select * from xoo where a = ? and a=?+1 and a = ?+2 order by a asc;

$int, $30;
select a from xoo union select ? from xoo order by a asc;

$int, $3;
select a from xoo difference select ? from xoo order by a asc;

$int, $3;
select a from xoo intersection select ? from xoo order by a asc;

drop xoo;