--insert/update/delete bind

create class xoo ( a int, b int);;

$int, $10, $int, $1
insert into xoo values(?, ?);

$int, $100, $int, $1;
update xoo set a = a + ? where b = ?; 
select * from xoo;

$int, $100, $varchar, $1;
update xoo set a = a + ? where b = ?; 
select * from xoo;

$int, $1, $varchar, $1;
update xoo set a = a + decode(?, 100, 0, -1) where b = to_number(?); 
select * from xoo;

$int, $1;
delete from xoo where b = ?;

select * from xoo;

drop xoo;
