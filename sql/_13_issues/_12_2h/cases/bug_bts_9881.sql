set names utf8;

drop table if exists t1;
create table t1(i int primary key,s string collate utf8_ko_cs_uca);
insert into t1 values(1,'金');
show collation union show tables;
show tables union show collation;
show collation union show indexes from t1;
show columns from t1 union show collation;
show collation union show collation;

drop t1;
set names iso88591;
