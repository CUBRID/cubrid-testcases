--test for preparestatement query including simple operation with ? (chartype)
--+ holdcas on;

create class xoo ( a int, b string );

insert into xoo values(1,'1');
insert into xoo values(1,'11');
insert into xoo values(1,'3');
insert into xoo values(2, '2');
insert into xoo values(3, '3');

$varchar, $1, $varchar, $1;
select a,b from xoo where b || 1 = ? + ?;
$int, $1, $int, $1;
select a,b from xoo where b || 1 = ? + ?;
$int, $1, $int, $1;
select a,b from xoo where b || 1 = ? || ?;
$int, $1, $int, $1;
select a,b from xoo where ? = ? order by 1,2;

$varchar, $1, $varchar, $1;
select a,b from xoo where (? + ?) = b order by 1,2;

$varchar, $1, $varchar, $1;
select a,b from xoo where (? + ?) = '11' order by 1,2;

$int, $1, $int, $1;
select  * from xoo where ? + ? = b order by 1,2;

$int, $1,$int, $1,$int, $1,$int, $1,$int, $1,$int, $1;
select a,b from xoo where (? + ? + ((? + ?) + ?) + ? + ?) = '111111' order by 1,2;

drop xoo;

commit;
--+ holdcas off;

