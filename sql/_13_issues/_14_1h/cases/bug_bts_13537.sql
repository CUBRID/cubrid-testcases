autocommit off;
set names utf8;
SET SYSTEM PARAMETERS 'insert_execution_mode=0';
drop table if exists t;
drop table if exists ll;

create table t(s string, c clob);
insert into t values('c',_utf8'។ល។');
insert into t values('d',_utf8'ヽ');

create table ll(s1 string collate utf8_de_exp,s2 string collate iso88591_en_ci);
insert into ll select clob_to_char(c using utf8),clob_to_char(c using iso88591) from t;

select length(s1),length(s2) from ll order by length(s1);

drop t;
drop ll;
set names iso88591;

set names utf8;
SET SYSTEM PARAMETERS ' insert_execution_mode=3';
drop table if exists t;
drop table if exists ll;

create table t(s string, c clob);
insert into t values('c',_utf8'។ល។');
insert into t values('d',_utf8'ヽ');

create table ll(s1 string collate utf8_de_exp,s2 string collate iso88591_en_ci);
insert into ll select clob_to_char(c using utf8),clob_to_char(c using iso88591) from t;

select length(s1),length(s2) from ll order by length(s1);

drop t;
drop ll;
set names iso88591;
rollback;


autocommit on;
