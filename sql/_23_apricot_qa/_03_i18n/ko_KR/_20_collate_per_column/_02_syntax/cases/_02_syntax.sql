--+ holdcas on;
set names utf8;
create table t1 (s1 string collate 'utf8_ko_cs_uca');

create table t2 (s1 string collate 'utf8_gen');


insert into t1 values ('가'),( '伽');

insert into t2 values ('가'),( '伽');


alter table t1 add d1 date default date '2001-11-12';
alter table t2 add d1 date default date '2001-11-12';


alter table t1 add sd1 varchar(10) collate utf8_ko_cs_uca default '각';
alter table t2 add sd1 varchar(10) collate utf8_gen default '刻';

alter table t1 add st1 char(10) collate utf8_ko_cs_uca default '10:11';
alter table t2 add st1 char(10) collate utf8_gen default '10:11';

alter table t1 add nc1 national char(10) collate utf8_ko_cs_uca default n'가';
alter table t2 add nc1 national char(10) collate utf8_gen default n'가';

alter table t1 add ns1 national char varying(10) collate utf8_ko_cs_uca default n'가';
alter table t2 add ns1 national char varying(10) collate utf8_gen default n'가';

desc t1;
desc t2;

SHOW full COLUMNS FROM t1;
SHOW FULL COLUMNS FROM t2;
drop t1;
drop t2;
set names iso88591;
commit;
--+ holdcas off;

