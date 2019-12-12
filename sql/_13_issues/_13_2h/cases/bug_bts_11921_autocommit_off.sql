autocommit off;

create table w(i varchar(20), j varchar(20), a int);
create table t(i varchar(20), j varchar(20), a int);
insert w values('a','b', 100);

prepare st from 'merge into t using (select ? i, ? j, ?+1 a from w) d on t.i = d.i when matched then update set i = 0 when not matched then insert values (d.i, d.j, d.a)';
execute st using 'x','y', 999;
select * from t;

deallocate prepare st;

drop table w;
drop table t;

rollback;
autocommit on;

