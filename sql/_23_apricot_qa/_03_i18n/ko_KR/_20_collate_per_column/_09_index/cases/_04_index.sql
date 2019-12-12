create table t(s1 string collate utf8_km_exp,s2 char(100) collate utf8_ja_exp,s3 varchar(100) collate utf8_de_exp);
create index idx1 on t(s1(2));
create index idx2 on t(s2(2));
create index idx3 on t(s3(2));
create index idx4 on t(s3(100));
drop table t;