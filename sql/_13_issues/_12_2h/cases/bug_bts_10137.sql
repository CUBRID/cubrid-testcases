set names utf8;

drop table if exists t;
create table t(s string collate utf8_bin,i int,ss string collate utf8_bin);
insert into t values('female',1,'female');
create view v10137 as select * from t;

alter table t change column s s string collate utf8_de_exp;
alter table t change column i i string;
alter table t change column ss ss int;
show full columns from v10137;
select * from t;

drop t;
drop v10137;

set names iso88591;
