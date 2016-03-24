--use host variables in conditions
create table t1(e1 enum('a', 'b'), e2 enum('Yes', 'No', 'Cancel'), e3 enum ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'), e4 enum('x', 'y', 'z'));
insert into t1 values(1, 1, 1, 1);
insert into t1 values(2, 3, 7, 3);
insert into t1 values('b', 'No', 'Tuesday', 'y');
insert into t1 values('a', 'Yes', 'Friday', 'x');
insert into t1 values('a', 'Cancel', 'Thursday', 'z');
insert into t1 values('b', 1, 4, 'z');

select * from t1 order by 1, 2, 3, 4;

prepare x from 'select * from t1 where e3 < ? and (e1 <> ? or e2 <> ?) order by 1, 2, 3, 4';
execute x using 6, 2, 3;
execute x using 'Sunday', 'a', 'Yes';
drop prepare x;

prepare x from 'update t1 set e1=?, e2=? where e3=?';
execute x using 1, 'No', 7;
select * from t1 order by 1, 2, 3, 4;
execute x using 'a', 3, 'Wednesday' ;
select * from t1 order by 1, 2, 3, 4;
drop prepare x;

prepare x from 'insert into t1 values (?, ?, ?, ?)';
execute x using 2, 'Yes', 2, 3;
select * from t1 order by 1, 2, 3, 4;
execute x using 'a', 2, 'Monday', 'y';
select * from t1 order by 1, 2, 3, 4;
drop prepare x;

drop table t1;