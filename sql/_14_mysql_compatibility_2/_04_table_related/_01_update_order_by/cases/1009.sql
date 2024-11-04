-- UPDATE ... ORDER BY    + trigger  + HOST variables

-- PREPARE statement UPDATE ORDER BY ... with LIMIT HV,    1) 
create table t1 (i1 integer ,i2 integer, i3 integer,i4 integer );
create table t2 (a int auto_increment unique, i integer );
insert into t1 values (4,4,4,4), (1,7,1,7) , (7,1,7,1),(2,6,2,6), (3,5,3,5), (6,2,6,2),(5,3,5,3);
select * from t1 order by i3;

create trigger tr1_uo before update on t1
execute insert t2 set i=obj.i1;

prepare st from 'update t1 set i1=? order by i3 limit ?';
execute st using 13,5;
deallocate prepare st;

select * from t1 order by i3;
select * from t2 order by a;


-- reset values:
update t1 set i1=i3;
delete from t2;
-- redo the test with different values
prepare st from 'update t1 set i1=? order by i3 limit 4';
execute st using 13;
deallocate prepare st;

select * from t1 order by i3;
select * from t2 order by a;

drop trigger tr1_uo;
drop t1;
drop t2;

