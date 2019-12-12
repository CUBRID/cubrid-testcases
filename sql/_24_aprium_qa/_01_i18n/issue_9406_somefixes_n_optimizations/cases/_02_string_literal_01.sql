set names utf8;
drop table if exists t;
create table t(s string collate iso88591_bin);insert into t values('ß');
select cast(s as string collate utf8_de_exp) from t;
select s collate utf8_de_exp from t;
select cast(_iso88591'ß' as string collate utf8_de_exp);
select _iso88591'ß' collate utf8_de_exp;
set names iso88591;
select cast('ß' as string collate utf8_de_exp);
select 'ß' collate utf8_de_exp;

drop table if exists t;
create table t(s string collate utf8_bin);insert into t values('ß');
select cast(s as string collate iso88591_bin) from t;
select s collate iso88591_bin from t;
select cast(_utf8'ß' as string collate iso88591_bin);
select _utf8'ß' collate iso88591_bin;
set names utf8;
select cast('ß' as string collate iso88591_bin);
select 'ß' collate iso88591_bin;

drop table if exists t;
create table t(s string collate utf8_bin);insert into t values('金');
select cast(s as string collate euckr_bin) from t;
select s collate euckr_bin from t;
select cast(_utf8'金' as string collate euckr_bin);
select _utf8'金' collate euckr_bin;
set names utf8;
select cast('金' as string collate euckr_bin);
select '金' collate euckr_bin;

drop table if exists t;
create table t(s string collate euckr_bin);
set names euckr;
insert into t values('a');
select cast(s as string collate utf8_bin) from t;
select s collate utf8_bin from t;
select cast(_euckr'a' as string collate utf8_bin);
select _euckr'a' collate utf8_bin;
set names euckr;
select cast('a' as string collate utf8_bin);
select 'a' collate utf8_bin;

drop table if exists t;
create table t(s string collate euckr_bin);
set names euckr;
insert into t values('a');
select cast(s as string collate iso88591_bin) from t;
select s collate iso88591_bin from t;
select cast(_euckr'a' as string collate iso88591_bin);
select _euckr'a' collate iso88591_bin;
set names euckr;
select cast('a' as string collate iso88591_bin);
select 'a' collate iso88591_bin;

drop table if exists t;
create table t(s string collate iso88591_bin);insert into t values('ß');
select cast(s as string collate euckr_bin) from t;
select s collate euckr_bin from t;
select HEX(cast(_iso88591'ß' as string collate euckr_bin));
select _iso88591'ß' collate euckr_bin;
set names iso88591;
select HEX(cast('ß' as string collate euckr_bin));
select 'ß' collate euckr_bin;

drop t;
set names iso88591;
