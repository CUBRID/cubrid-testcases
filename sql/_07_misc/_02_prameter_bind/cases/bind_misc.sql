--test exception process where error happens

create class xoo ( a int unique);
insert into xoo values(1);

$varchar, $1111111111111111111111111
insert into xoo values(?);

$varchar, $1
insert into xoo values(?);

$int, $1111111
insert into xoo values(?);

$int, $1, $int, $100
insert into xoo values(? * ?);
insert into xoo values(80 * 10);
$int, $10, $int, $20
insert into xoo select ? + ? from db_root;

select * from xoo order by 1;

drop xoo;