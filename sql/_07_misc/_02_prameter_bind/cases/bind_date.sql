--bind date type
autocommit off;

create class xoo ( a date);

$int, $0
insert into xoo values(?);
$varchar, $1
insert into xoo values(?);
$nchar, $2
insert into xoo values(?);
$bit, $3
insert into xoo values(?);
$bit, $4
insert into xoo values(?);
$numeric, $5
insert into xoo values(?);
$smallint, $6
insert into xoo values(?);
$monetary, $7
insert into xoo values(?);
$float, $8
insert into xoo values(?);
$double, $9
insert into xoo values(?);
$date, $2008-01-01;
insert into xoo values(?);
$time, $16:21:00;
insert into xoo values(?);
$timestamp, $2008-01-01 16:21:00;
insert into xoo values(?);

select count(*) from xoo order by 1;

$int, $0
select * from xoo where a = ?;
$varchar, $1
select * from xoo where a = ?;
$nchar, $2
select * from xoo where a = ?;
$bit, $3
select * from xoo where a = ?;
$bit, $4
select * from xoo where a = ?;
$numeric, $5
select * from xoo where a = ?;
$smallint, $6
select * from xoo where a = ?;
$monetary, $7
select * from xoo where a = ?;
$float, $8
select * from xoo where a = ?;
$double, $9
select * from xoo where a = ?;
$date, $2008-01-01;
select * from xoo where a = ?;
$time, $16:21:00;
select * from xoo where a = ?;
$timestamp, $2008-01-01 16:21:00;
select count(*) from xoo where a = ?;

drop xoo;
rollback;

autocommit on;

