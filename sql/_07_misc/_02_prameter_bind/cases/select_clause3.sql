--bind parmaeter in select cluase with char type
create class xoo ( a string);
insert into xoo values(1);

$int, $100, $int , $1
select ?||1 from xoo where ? = a;
$int, $100, $int ,  $1
select ? + 1 from xoo where ? = a;
$int, $100, $int , $200, $int , $1
select (?) || (?)  from xoo where ? = a;
$int, $100, $int ,$1
select ? + 100 from xoo where ? = a;
$int ,$1
select 100 + 100 from xoo where ? = a;

$char, $100, $char , $1
select ?||1 from xoo where ? = a;
$char, $100, $char ,  $1
select ? + 1 from xoo where ? = a;
$char, $100, $char , $200, $char , $1
select (?) || (?)  from xoo where ? = a;

$char, $100, $char , $1
select to_number(?) from xoo where ? = a;
$char, $100, $char , $1
select to_char(?) from xoo where ? = a;
$double, $100, $double , $1
select to_char(?) from xoo where ? = a;
$double, $100, $double , $1
select cast(? as string) from xoo where ? = a;
$double, $100, $double , $1
select cast(? as int) from xoo where ? = a;
$double, $100, $double , $1
select cast(? as double) from xoo where ? = a;

$int, $1, $int , $100, $int, $1
select decode(a,?,?,120) from xoo where ? = a;
$int, $1, $char , $100, $int, $1
select decode(a,?,?,120) from xoo where ? = a;
$varchar, $1, $char , $100, $int, $1
select decode(a,?,?,120) from xoo where ? = a;
$varchar, $1, $char , $100, $int, $0, $int, $1
select case when a = ? then ? else ? end from xoo where ? = a;

$varchar, $1, $int , $100, $int, $1
select (select ? from db_root) * ? * a from xoo where ?=a;
$int, $1, $int , $100, $int, $1
select (select ? from db_root) * ? * a from xoo where ?=a;
$int, $200, $int , $100, $int, $1
select (select ? from db_root)  + (select ? from xoo where a = 1) from xoo 
where ?=a;
$int, $200, $char , $100, $int, $1
select (select ? from db_root)  + (select ? from xoo where a = 1) from xoo 
where ?=a;
$int, $200, $char , $100, $int, $1
select (select ? from db_root)  + (select date'2010-01-01' + ? from xoo where a = 1) from xoo 
where ?=a;

$numeric, $100, $int , $200, $int , $1
select ? + ?  from xoo where ? = a;
drop xoo;
