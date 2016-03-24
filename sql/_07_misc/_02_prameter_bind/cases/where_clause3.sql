--bind parameter in where clause ( set type)

create class xoo ( a int, b int);
insert into xoo values(1, 1);
insert into xoo values(2, 2);
insert into xoo values(3, 3);

$int, $3;
select a from xoo where a in {1,2,?};
$int, $3;
select a from xoo where a in {1,2} + {?};
$int, $2;
select a from xoo where a in {1,2} - {?};
$int, $2;
select a from xoo where set{1,2} superset set{?};
drop xoo;