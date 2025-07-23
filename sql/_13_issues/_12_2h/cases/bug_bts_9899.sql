set names utf8;

drop table if exists t;
create table t(i int,s string);
insert into t values(65,'a');
select coercibility(collation(s)) from t;
select coercibility(substr(s,1,1)) from t;
select coercibility(chr(65)),coercibility(chr(i)) from t;

set names iso88591;
select coercibility(collation(s)) from t;
select coercibility(substr(s,1,1)) from t;
select coercibility(chr(65)),coercibility(chr(i)) from t;

set names euckr;
select coercibility(collation(s)) from t;
select coercibility(substr(s,1,1)) from t;
select coercibility(chr(65)),coercibility(chr(i)) from t;

drop t;
set names iso88591;
