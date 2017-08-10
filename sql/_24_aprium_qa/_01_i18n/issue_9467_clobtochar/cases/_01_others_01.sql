set names utf8;

drop table if exists t;
drop table if exists ll;

create table t(s string, c clob);
insert into t values('a','a');
select clob_to_char(c using iso88591) collate iso88591_en_cs from t where clob_to_char(c using iso88591) collate iso88591_en_ci like 'A';
select clob_to_char(c using iso88591) collate iso88591_en_cs from t where clob_to_char(c using iso88591) collate iso88591_en_ci like 'a';
insert into t values('c',_utf8'។ល។');
insert into t values('d',_utf8'ヽ');
select length(clob_to_char(c using utf8)) from t;
select length(clob_to_char(c using iso88591)) from t;

alter table t change column c c clob collation utf8_de_exp;

create table ll(s1 string collate utf8_de_exp,s2 string collate iso88591_en_ci);
insert into ll select clob_to_char(c using utf8),clob_to_char(c using iso88591) from t;
insert into ll select clob_to_char(c using iso88591),clob_to_char(c using utf8) from t;
select length(s1),length(s2) from ll;

drop t;
drop ll;

set names iso88591;
