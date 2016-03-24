--+ holdcas on;
set names utf8;

drop table if exists t1;
create table t1(a varchar(100) charset binary); 
insert into t1 values('test');

select coercibility(a), COERCIBILITY(concat(a,a)), COERCIBILITY(a||a) from t1;
alter table t1 collate utf8_bin;
alter table t1 add column s string;
select coercibility(s), COERCIBILITY(concat(s,s)), COERCIBILITY(s||s) from t1;
alter table t1 add column s2 string charset iso88591;
select coercibility(s2), COERCIBILITY(concat(s2,s2)), COERCIBILITY(s2||s2) from t1;
select COERCIBILITY(concat(a,s)), COERCIBILITY(a||s) from t1;

drop t1;
set names iso88591;

commit;
--+ holdcas off;