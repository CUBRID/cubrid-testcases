set names utf8;
drop table if exists t;
create table t(s string collate utf8_bin,s2 string collate utf8_bin);
insert into t(s) values('g'),('G'),('GI'),('gÄ'),('äA'),('AE'),('Ä');
create index i on t(substring(s,1,1));
alter table t change s s string collate utf8_de_exp;
alter table t partition by range(s) (partition p0 values less than maxvalue);
select * from t order by 1;
update t set s=s||s2;
select * from t order by 1;
drop t;

create table t(s string collate utf8_bin);
insert into t values('g'),('G'),('GI'),('gÄ'),('äA'),('AE'),('Ä');
create index i on t(substring(s,1,1));
select * from t where substring(s,1,1)='g' order by 1;
alter table t change s s string collate utf8_de_exp;
select * from t where substring(s,1,1)='g' order by 1;
drop t;

set names iso88591;
