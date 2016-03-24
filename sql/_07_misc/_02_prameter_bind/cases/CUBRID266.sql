--bind false type in function

create class xoo ( a int, b string);
insert into xoo values(1, '111');
insert into xoo values(2, '222');
$varchar, $1, $varchar, $1;
select a from xoo where a  = to_number(?) and a = ?;
$varchar, $1, $int, $1;
select a from xoo where a  = to_number(?) and a = ?;
select a from xoo where a = to_number('1') and a = 1;
drop xoo;