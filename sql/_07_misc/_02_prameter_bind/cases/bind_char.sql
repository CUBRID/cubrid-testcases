--bind character type
create class xoo ( a varchar(10));

$int, $0;
insert into xoo values(?);
$varchar, $1;
insert into xoo values(?);
$nchar, $2;
insert into xoo values(?);
$bit, $3;
insert into xoo values(?);
$bit, $4;
insert into xoo values(?);
$numeric, $5;
insert into xoo values(?);
$smallint, $6;
insert into xoo values(?);
$monetary, $7;
insert into xoo values(?);
$float, $8;
insert into xoo values(?);
$double, $9;
insert into xoo values(?);
$date, $10;
insert into xoo values(?);
$time, $11;
insert into xoo values(?);
$timestamp, $12;
insert into xoo values(?);

select * from xoo order by 1;

$int, $0;
select * from xoo where a = ?;
$varchar, $1;
select * from xoo where a = ?;
$nchar, $2;
select * from xoo where a = ?;
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
select * from xoo where a = ?;;
$timestamp, $12;
select * from xoo where a = ?;


drop xoo;