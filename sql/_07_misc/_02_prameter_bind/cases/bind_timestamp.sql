--bind timestamp type

autocommit off;
create class xoo ( a timestamp);


$CHAR, $3;
insert into xoo values(?);
$bit, $4;
insert into xoo values(?);

select * from xoo order by 1;

$bit, $3;
select * from xoo where a = ?;
$bit, $4;
select * from xoo where a = ?;
$numeric, $5;
select * from xoo where a = ?;
$smallint, $6;
select * from xoo where a = ?;
$monetary, $7;
select * from xoo where a = ?;
$float, $8;
select * from xoo where a = ?;
$double, $9;
select * from xoo where a = ?;
$date, $10;
select * from xoo where a = ?;
$time, $11;
select * from xoo where a = ?;
$timestamp, $12;
select * from xoo where a = ?;

$date, $01:01:02;
select * from xoo where a = ?;
$time, $01:01:02;
select * from xoo where a = ?;

drop xoo;
rollback;

autocommit on;

