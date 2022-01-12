create table xoo(c1 int, c2 int primary key);
create index i_xoo_c1 on xoo (c1);
insert into xoo values (1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (8,8), (9,9), (10,10);
prepare q1 from 'select c1 from xoo where ((c1 > ? and c1 < ?) or (c1 > ? and c1 < ?) or (c1 > ? and c1 < ?)) using index i_xoo_c1 order by 1';
execute q1 using 1,5,7,9,4,10;

prepare st1 from 'select c1 from xoo where ((c1 > ? and c1 < ?) or (c1 > ? and c1 < ?) and (c1 > ? and c1 < ?)) using index i_xoo_c1 order by 1';
execute st1 using 1,5,7,9,4,10;

create table t1(a int primary key);
insert into t1(a) values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

prepare st from 'select * from t1 where a>? or a<?';
execute st using 1,2;
execute st using 1,1;
execute st using 10,1;

prepare st2 from 'select * from t1 where a>? and a<?;';
execute st2 using 1,2;
execute st2 using 10,1;

drop prepare q1;
drop prepare st1;
drop prepare st;
drop prepare st2;
drop t1;
drop xoo;
