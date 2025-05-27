drop table if exists t;
create table t(c char(30));
insert into t value ('3');
insert into t value (chr(255));
insert into t value (concat(chr(255), chr(255)));
prepare st from 'select count(*) from t where c like ?';
execute st using '%';
deallocate prepare st;

prepare st from 'select * from t where c like ? order by 1';
execute st using '%';
deallocate prepare st;
drop t;

create table t(c char(255));
insert into t value ('3');
insert into t value ('');
insert into t value (concat(chr(255), chr(255)));
prepare st from 'select count(*) from t where c like ?';
execute st using '%';
deallocate prepare st;
drop t;

create table t(c char(10));
insert into t value ('3');
insert into t value (chr(14909886));
select count(*) from t where c like '%';
prepare st from 'select count(*) from t where c like ?';
execute st using '%';
deallocate prepare st;
drop t;

