--+ holdcas on;
set names utf8;
create table t(col1 char(10)  collate utf8_ko_cs_uca,col2 varchar(10)  collate utf8_ko_cs_uca,col3 nchar(10)  collate utf8_ko_cs_uca,col4 NCHAR VARYING(10)  collate utf8_ko_cs_uca,col5 string  collate utf8_ko_cs_uca);
insert into t values('a','a',N'a',N'a','a');
insert into t values('1','1',N'1',N'1','1');
insert into t values('ō','ō',N'ō',N'ō','ō');
insert into t values('가','가',N'가',N'가','가');
insert into t values('伽','伽',N'伽',N'伽','伽');
insert into t values('힐','힐',N'힐',N'힐','힐');
insert into t values('힐','힐',N'힐',N'힐','힐');


select min(col1) from t;
select min(col2) from t;
select min(col3) from t;
select min(col4) from t;
select min(col5) from t;



select min(DISTINCT col1) from t;
select min(DISTINCT col2) from t;
select min(DISTINCT col3) from t;
select min(UNIQUE col4) from t;
select min(UNIQUE col5) from t;

drop table t;
set names iso88591;
commit;
--+ holdcas off;