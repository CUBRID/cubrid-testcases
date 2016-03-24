--+ holdcas on;
set names utf8;
drop table if exists t1;
drop table if exists t2;
create table t1(col1 varchar(20) collate binary, col2 varchar(20));
create table t2(col1 varchar(20) collate utf8_bin, col2 varchar(20));
insert into t1 values('我们我中中国','ÀÏàó123abc');
insert into t2 values('我们我中中国','ÀÏàó123abc' collate binary);

select * from t1 where exists(select * from t1,t2 where t1.col1=t2.col1);
select * from t1 where exists(select * from t1,t2 where t1.col2=t2.col2);

drop table t1;
drop table t2;

set names iso88591;
commit;
--+ holdcas off;