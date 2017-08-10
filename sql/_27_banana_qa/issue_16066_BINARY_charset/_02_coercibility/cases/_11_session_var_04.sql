--+ holdcas on;

set names binary;
drop table if exists t;

select coercibility('a' collate binary);
select coercibility('' collate binary);
create table t(s string collate binary);
insert into t values('a');
select coercibility(s collate binary) from t; 
drop t;
create table t(s1 string collate binary,s2 string collate binary);
insert into t values('a','b');
select coercibility(s1||s2) from t;

select coercibility(USER()),coercibility(DATABASE()),coercibility(SCHEMA()),coercibility(VERSION());

set @a='a';
select coercibility(@a);

drop variable @a;
drop t;
set names iso88591;
commit;
--+ holdcas off;