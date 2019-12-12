--+ holdcas on;
set names utf8;
CALL add_user ('用户', '') ON CLASS db_user;
CALL add_user ('각', '') ON CLASS db_user;
set names iso88591 collate iso88591_en_cs;
alter user 각 PASSWORD 'Test';
set names iso88591 collate iso88591_en_ci;
CALL login ('用户', '') ON CLASS db_user;
CALL login ('각', 'test') ON CLASS db_user;
CALL login ('각', 'Test') ON CLASS db_user;
select substring(user(),0,1);
set names utf8 collate utf8_gen;
create table t(a string collate utf8_ko_cs_uca);
insert into t values('가'),('伽');
select * from t where a>'가';
-- column &Constants& functions
select a+substring(user(),0,1) from t where a>'가'+substring(user(),0,1) order by 1 desc;   
-- sub-expressions &Constants
select a+substring(user(),0,1) from t where cast(a as string collate utf8_ko_cs_uca)>'가';
-- sub-expressions&Constants&functions
select a+substring(user(),0,1) from t where cast(a as string collate utf8_ko_cs_uca)>substring(user(),0,1) order by 1 desc;
-- Constants&functions
select a+substring(user(),0,1) from t where substring(user(),0,1)>'가';
-- sub-expressions&Constants&Special functions
--select a+substring(user(),0,1) from t where cast(a as string collate utf8_ko_cs_uca)>'가'+user();
-- sub-expressions&Constants&Functions
select a+substring(user(),0,1) from t where cast(a as string collate utf8_ko_cs_uca)>'가'+substring(user(),0,1) order by 1 desc; 

-- Columns&Functions
select a+substring(user(),0,1) from t where a<substring(user(),0,1);
-- Columns&sub-expressions
select a+substring(user(),0,1) from t where a>cast('가' as string collate utf8_gen);
-- Columns&Constants
select a+substring(user(),0,1) from t where a>'가';
-- Columns&sub-expressions&Constants&Functions

select a+substring(user(),0,1) from t where a<cast('각' as string collate utf8_gen)+'가'+substring(user(),0,1) order by 1 desc;
CALL login ('Dba', '') ON CLASS db_user;
drop user 用户;
drop table t;
drop user 각;

set names iso88591;
commit;
--+ holdcas off;
