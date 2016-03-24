--bind parameter in select clause

create class xoo ( a int);
insert into xoo values(1);

$int, $100, $int , $1
select ? from xoo where ? = a;
$varchar, $100, $int , $1
select ? from xoo where ? = a;
$char, $100, $int , $1
select ? from xoo where ? = a;
$double, $100, $int , $1
select ? from xoo where ? = a;
$float, $100, $int , $1
select ? from xoo where ? = a;
$date, $100, $int , $1
select ? from xoo where ? = a;
$time, $100, $int , $1
select ? from xoo where ? = a;
$timestamp, $100, $int , $1
select ? from xoo where ? = a;
$bit, $100, $int , $1
select ? from xoo where ? = a;

drop xoo;
