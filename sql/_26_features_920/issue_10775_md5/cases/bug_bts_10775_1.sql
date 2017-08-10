set names utf8;
create table t (c char(128) charset utf8);
insert into t values('a');
select md5(c) from t;
drop table t;

set names euckr;
create table t (c char(128) charset euckr);
insert into t values('a');
select md5(c) from t;
drop table t;

set names iso88591;

