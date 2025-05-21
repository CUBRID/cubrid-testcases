-- tests with HOST variables 

-- PREPARE statement UPDATE ORDER BY ... with LIMIT HV,    1) 
create table tab1 (i1 integer ,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);
select * from tab1 order by i1,i2;

prepare st from 'update tab1 set i1=? order by i3,i2 limit ?';
execute st using 13,2;
deallocate prepare st;
select * from tab1 order by i2,i1;

update tab1 set i1=i2;
select * from tab1 order by i2,i1;

prepare st from 'update tab1 set i1=? order by i3,i2 limit ?';
execute st using 13,2;
deallocate prepare st;
select * from tab1 order by i2,i1;


drop table tab1;


-- PREPARE statement UPDATE ORDER BY ... with LIMIT HV  ,   2)  
create table tab1 (i1 integer ,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);
select * from tab1 order by i2,i1;

prepare st from 'update tab1 set i1=13-? order by i3,i2 limit ?';
execute st using 13,2;
deallocate prepare st;
select * from tab1 order by i2,i1;


update tab1 set i1=i2;
select * from tab1 order by i2,i1;

prepare st from 'update tab1 set i1=13-? order by i3,i2 limit ?';
execute st using 13,2;
deallocate prepare st;
select * from tab1 order by i2,i1;

drop table tab1;


-- PREPARE statement UPDATE ORDER BY ... with LIMIT const   3)
create table tab1 (i1 integer ,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);
select * from tab1 order by i2,i1;

prepare st from 'update tab1 set i1=? order by i3,i2 limit 2';
execute st using 13;
deallocate prepare st;
select * from tab1 order by i2,i1;

update tab1 set i1=i2;
select * from tab1 order by i2,i1;

prepare st from 'update tab1 set i1=? order by i3,i2 limit 2';
execute st using 13;
deallocate prepare st;
select * from tab1 order by i2,i1;

drop table tab1;



-- PREPARE statement UPDATE ORDER BY ... with LIMIT const   4)
create table tab1 (i1 integer ,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);
select * from tab1 order by i2,i1;

prepare st from 'update tab1 set i1=0 order by i2,i3';
execute st;
deallocate prepare st;
select * from tab1 order by i2,i1;

update tab1 set i1=i2;
select * from tab1 order by i2,i1;

prepare st from 'update tab1 set i1=0 order by i2,i3';
execute st;
deallocate prepare st;
select * from tab1 order by i2,i1;

drop table tab1;



-- PREPARE statement UPDATE ORDER BY ... with LIMIT HV  ,  5)  
create table tab1 (i1 integer ,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);
select * from tab1 order by i2,i1;

prepare st from 'update tab1 set i3=?,i1=13-? order by i3,i2 limit ?';
execute st using -1,13,2;
deallocate prepare st;
select * from tab1 order by i2,i1;


update tab1 set i1=i2;
select * from tab1 order by i2,i1;

prepare st from 'update tab1 set i3=?,i1=13-? order by i3,i2 limit ?';
execute st using -1,13,2;
deallocate prepare st;
select * from tab1 order by i2,i1;

drop table tab1;

