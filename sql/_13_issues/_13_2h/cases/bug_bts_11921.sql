create table w(i varchar(20), j varchar(20));
create table t(i varchar(20), j varchar(20));
insert w values('a','b');

prepare st from 'merge into t using (select ? i, ? j from w) d on t.i = d.i when matched then update set i = 0 when not matched then insert values (d.i, d.j)';
execute st using 'x','y';
select * from t;

deallocate prepare st;

drop table w;
drop table t;

