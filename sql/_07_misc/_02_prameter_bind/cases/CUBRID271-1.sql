--test for preparestatement query including simple operation with ?
--+ holdcas on;

create class xoo ( a int, b string );

insert into xoo values(1,'1');
insert into xoo values(1,'2');
insert into xoo values(1,'3');
insert into xoo values(2, '2');
insert into xoo values(3, '3');

select a,b from xoo where a = 1 and b = '1';

$int, $1, $varchar, $1;
select a,b from xoo where a = ? and b = ?;

$int, $1, $int, $1;
select a,b from xoo where a = ? + ? order by 1,2;
$int, $1, $int, $1;
select a,b from xoo where  ? >= ? order by 1,2;
$int, $1, $int, $1;
select a,b from xoo where  a = ? / ? order by 1,2;
$int, $1, $int, $1;
select a,b from xoo where  a - 1 = ? - ? order by 1,2;
$int, $1, $int, $1;
select a,b from xoo where  a = ? * ? order by 1,2;

-- R1.1 bug issues
$int, $1, $int, $1, $int, $1, $int, $1, $int, $1;
select a,b from xoo where  (? + ? * ? - ? + 1 / ? ) ;
select a,b from xoo where  (1 + 1 * 1 - 1 + 1 / 1 );

$int, $1, $int, $1, $int, $1, $int, $1, $int, $1;
select a,b from xoo where  (? + ? * ? - ? + 1 / ? ) < 5;
select a,b from xoo where  (1 + 1 * 1 - 1 + 1 / 1 ) < 5 order by 1,2;

drop xoo;

commit;
--+ holdcas off;

