set system parameters 'create_table_reuseoid=no';
--bind parameter in where clause ( oid reference )

create class xoo ( a int);
create class yoo ( a int, b xoo);
insert into yoo values(1, insert into xoo values(10));
insert into yoo values(2, insert into xoo values(20));
$int, $30;
insert into yoo values(3, insert into xoo values(?));

$int , $10;
select a from yoo where b.a = ?;
$varchar , $10;
select a from yoo where b.a = ?;
$varchar , $30;
select a from yoo where b.a = ?;

$varchar , $10;
select a from yoo where b.a = ? + 10;

drop xoo, yoo;
set system parameters 'create_table_reuseoid=yes';
