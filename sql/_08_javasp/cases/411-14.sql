--+ holdcas on;

CREATE  Procedure  ptestinteger2(i inout int) as language java name 'SpTest5.ptestinteger2(java.lang.Integer[]) ';

select 10 into x from db_root;
call ptestinteger2(x);
select x from db_root;
$integer,$100
call ptestinteger2(?) ;
drop procedure ptestinteger2;

CREATE   Procedure  ptestdate1(i in out date) as language java name 'SpTest5.ptestdate2(java.sql.Date[]) ';
$varchar,$2000:12:28
call ptestdate1(?) ;
drop procedure ptestdate1;

CREATE   Procedure  ptestdate1(i in out date) as language java name 'SpTest5.ptestdate2(java.sql.Date[]) ';
select date'5/5/2008' into x from db_root;
call ptestdate1(x) ;
select x from db_root;
drop procedure ptestdate1;

CREATE   Procedure  ptestdate1(i in out date) as language java name 'SpTest5.ptestdate2(java.sql.Date[]) ';
$varchar,$10/28/2000
call ptestdate1(?) ;
drop procedure ptestdate1;

CREATE   Procedure  ptestdate1(i in out date) as language java name 'SpTest5.ptestdate2(java.sql.Date[]) ';
$varchar,$2000-10-28
call ptestdate1(?) ;
drop procedure ptestdate1;

CREATE  Procedure  ptestdate1(i in out date) as language java name 'SpTest5.ptestdate11(java.sql.Date[]) ';
$varchar,$2000:10:28
call ptestdate1(?) ;
$varchar,$2000-10-10
call ptestdate1(?) ;
$varchar,$2000/10/28
call ptestdate1(?) ;
drop procedure ptestdate1;

CREATE   Procedure  ptesttime2(i in out time) as language java name 'SpTest5.ptesttime2(java.sql.Time[]) ';
select time'1:1:1 am' into x from db_root;
call ptesttime2(x) ;
call ptesttime2(time'1:1:1 am');
select x from db_root;
drop procedure ptesttime2;

CREATE   Procedure  ptesttime2(i in out time) as language java name 'SpTest5.ptesttime3(java.sql.Time[]) ';
select time'1:1:1 am' into x from db_root;
call ptesttime2(x) ;
call ptesttime2(time'1:1:1 am');
select x from db_root;
drop procedure ptesttime2;

0_02.0_02 
call ptesttimestamp2(timestamp'5/5/2008 1:1:1 am') ;
select x from db_root;
drop procedure ptesttimestamp2;


CREATE Procedure ptesttime3(i inout string) as language java name 'SpTest5.ptesttime3(java.sql.Time[]) ';
select '10:10:10' into x from db_root;
call ptesttime3(x);
select x from db_root;
drop procedure ptesttime3;

CREATE   Procedure  ptesttimestamp2(i in out string) as language java name 'SpTest5.ptesttimestamp2(java.sql.Timestamp[]) ';
select '2001-11-02 10:11:12.1' into x from db_root;
call ptesttimestamp2(x) ;
select x from db_root;
select timestamp'5/5/2008 1:1:1 am' into x from db_root;
call ptesttimestamp2(x) ;
select  x from db_root;
$varchar,$2001-11-02 10:11:12.1
call ptesttimestamp2(?) ;
drop Procedure  ptesttimestamp2;


commit;

--+ holdcas off;

