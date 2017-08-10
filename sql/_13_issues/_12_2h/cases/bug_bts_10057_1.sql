set names utf8;
drop table if exists t;

select coercibility('a' collate utf8_de_exp_ai_ci);
select coercibility('' collate utf8_de_exp_ai_ci);
create table t(s string collate utf8_bin);
insert into t values('a');
select coercibility(s collate utf8_de_exp) from t; 
drop t;
create table t(s1 string collate utf8_gen,s2 string collate utf8_bin,s3 string collate iso88591_bin);
insert into t values('a','b','c');
select coercibility(s1),coercibility(s2),coercibility(s3) from t;

drop t;
create table t(s1 string collate utf8_gen,s2 string collate utf8_gen);
insert into t values('a','b');
select coercibility(s1||s2) from t;

drop t;
create table t(s1 string collate utf8_bin,s2 string collate utf8_bin);
insert into t values('a','b');
select coercibility(s1||s2) from t;

drop t;
create table t(s1 string collate utf8_bin,s2 string collate iso88591_bin);
insert into t values('a','b');
select coercibility(s1||s2) from t;

drop t;
create table t(s1 string collate iso88591_bin,s2 string collate iso88591_bin);
insert into t values('a','b');
select coercibility(s1||s2) from t;

select coercibility(USER()),coercibility(DATABASE()),coercibility(SCHEMA()),coercibility(VERSION());

set names utf8 collate utf8_gen;
select coercibility('a');

set names utf8 collate utf8_bin;
select coercibility('a');

set names iso88591 collate iso88591_bin;
select coercibility('a');

set @a='a';
select coercibility(@a);

drop variable @a;
drop t;
set names iso88591;


