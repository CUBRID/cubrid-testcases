drop table if exists t;
create table t(c char(30));
insert into t value ('3');
insert into t value (chr(255));
insert into t value (concat(chr(255), chr(255)));
prepare st from 'select count(*) from t where c like ?';
execute st using '%';

drop t;
