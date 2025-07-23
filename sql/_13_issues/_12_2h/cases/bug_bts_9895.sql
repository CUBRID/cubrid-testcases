set names utf8;

drop table if exists t1;
select COERCIBILITY(_utf8'dba' collate utf8_en_ci), COERCIBILITY(USER);
select COLLATION(_utf8'dba' collate utf8_en_ci), COLLATION(USER());
create table t1(a varchar(100)); 
insert into t1 values ('test');
select * from t1 where _utf8'dba' collate utf8_en_ci = USER;
select * from t1 where 'dba' = USER;
select * from t1 where 'DBA' = USER;

drop t1;
set names iso88591;

