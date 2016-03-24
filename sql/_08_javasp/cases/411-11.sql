autocommit off;



CREATE  Procedure  ptestint1(i inout int) as language java name 'SpTest5.ptestint1(int) ';

select '10' into x from db_root;
call ptestint1(x);
call ptestint1('10');
call ptestint1('xx');
call ptestint1(null);
$varchar,$10;
call ptestint1(?) ;

drop procedure ptestint1;


CREATE  Procedure  ptestint2(i inout int) as language java name 'SpTest5.ptestint2(int[]) ';

select '10' into x from db_root;
call ptestint2(x);
select x from db_root;
call ptestint2('10');
call ptestint2('xx');
call ptestint2(null);
$varchar,$10;
call ptestint2(?) ;
drop procedure ptestint2;

--&&&&&&&&&&���� ���� �?7�? ***************


CREATE  Procedure  ptestint4(i in date) as language java name 'SpTest5.ptestint4(int[]) ';
select 1 into x from db_root;
call ptestint4(x);
select x from db_root;
drop procedure ptestint4;

CREATE  Procedure  ptestdate1(i date) as language java name 'SpTest5.ptestdate1(java.sql.Date) ';
select date'5/5/2008' into x from db_root;
call ptestdate1(x);
select x from db_root;
drop procedure ptestdate1;

CREATE  Procedure  ptestdate1(i in date) as language java name 'SpTest5.ptestdate1(java.sql.Date) ';
select date'5/5/2008' into x from db_root;
call ptestdate1(x);
select x from db_root;
drop procedure ptestdate1;

CREATE  Procedure  ptestdate1(i out date) as language java name 'SpTest5.ptestdate1(java.sql.Date) ';
select date'5/5/2008' into x from db_root;
call ptestdate1(x);
call ptestdate1(date'5/5/2008');
select x from db_root;
drop procedure ptestdate1;

CREATE  Procedure  ptestdate1(i inout date) as language java name 'SpTest5.ptestdate1(java.sql.Date) ';
select date'5/5/2008' into x from db_root;
call ptestdate1(x);
select x from db_root;
drop procedure ptestdate1;

CREATE  Procedure  ptestdate1(i date) as language java name 'SpTest5.ptestdate1(java.util.Date) ';
select date'5/5/2008' into x from db_root;
call ptestdate1(x);
select x from db_root;
drop procedure ptestdate1;

CREATE  Procedure  ptestdate1(i in date) as language java name 'SpTest5.ptestdate1(java.util.Date) ';
select date'5/5/2008' into x from db_root;
call ptestdate1(x);
select x from db_root;
drop procedure ptestdate1;

CREATE  Procedure  ptestdate1(i out date) as language java name 'SpTest5.ptestdate1(java.util.Date) ';
select date'5/5/2008' into x from db_root;
call ptestdate1(x);
select x from db_root;
drop procedure ptestdate1;

CREATE  Procedure  ptestdate1(i inout date) as language java name 'SpTest5.ptestdate1(java.util.Date) ';
select date'5/5/2008' into x from db_root;
call ptestdate1(x);
select x from db_root;
drop procedure ptestdate1;

CREATE  Procedure  ptestdate2(i date) as language java name 'SpTest5.ptestdate2(java.sql.Date[]) ';
select date'5/5/2008' into x from db_root;
call ptestdate2(x);
select x from db_root;
drop procedure ptestdate2;

CREATE  Procedure  ptestdate2(i in date) as language java name 'SpTest5.ptestdate2(java.sql.Date[]) ';
select date'5/5/2008' into x from db_root;
call ptestdate2(x);
select x from db_root;
drop procedure ptestdate2;

CREATE  Procedure  ptestdate2(i out date) as language java name 'SpTest5.ptestdate2(java.sql.Date[]) ';
select date'5/5/2008' into x from db_root;
call ptestdate2(x);
select x from db_root;
drop procedure ptestdate2;

CREATE  Procedure  ptestdate2(i inout date) as language java name 'SpTest5.ptestdate2(java.sql.Date[]) ';
select date'5/5/2008' into x from db_root;
call ptestdate2(x);
select x from db_root;
drop procedure ptestdate2;



CREATE  Procedure  ptesttime2(i inout time) as language java name 'SpTest5.ptesttime2(java.sql.Time[]) ';
select time'1:1:1 am' into x from db_root;
call ptesttime2(x);
select x from db_root;
drop procedure ptesttime2;


CREATE    Procedure  ptesttime2(i in time) as language java name 'SpTest5.ptesttime2(java.sql.Time[]) ';
select time'1:1:1 am' into x from db_root;
call ptesttime2(x);
select x from db_root;


drop procedure ptesttime2;
CREATE  Procedure  ptesttime2(i out time) as language java name 'SpTest5.ptesttime2(java.sql.Time[]) ';
select time'1:1:1 am' into x from db_root;
call ptesttime2(x);
select x from db_root;


drop procedure ptesttime2;
CREATE  Procedure  ptesttime2(i time) as language java name 'SpTest5.ptesttime2(java.sql.Time[]) ';
select time'1:1:1 am' into x from db_root;
call ptesttime2(x);
select x from db_root;

drop procedure ptesttime2;

CREATE  Procedure  ptesttime3(i inout time) as language java name 'SpTest5.ptesttime3(java.sql.Time[]) ';
select time'1:1:1 am' into x from db_root;
call ptesttime3(x);
select x from db_root;

drop procedure ptesttime3;
CREATE  Procedure  ptesttime3( i  in time) as language java name 'SpTest5.ptesttime3(java.sql.Time[]) ';
select time'1:1:1 am' into x from db_root;
call ptesttime3(x);
select x from db_root;


drop procedure ptesttime3;
CREATE  Procedure  ptesttime3(i out time) as language java name 'SpTest5.ptesttime3(java.sql.Time[]) ';
select time'1:1:1 am' into x from db_root;
call ptesttime3(x);
select x from db_root;


drop procedure ptesttime3;
CREATE  Procedure  ptesttime3(i time) as language java name 'SpTest5.ptesttime3(java.sql.Time[]) ';
select time'1:1:1 am' into x from db_root;
call ptesttime3(x);
select x from db_root;




CREATE  Procedure  ptesttimestamp2(i inout timestamp) as language java name 'SpTest5.ptesttimestamp2(java.sql.Timestamp[]) ';
select timestamp'5/5/2008 1:1:1 am' into x from db_root;
call ptesttimestamp2(x);
select x from db_root;

drop procedure ptesttimestamp2;
CREATE  Procedure  ptesttimestamp2( i in timestamp) as language java name 'SpTest5.ptesttimestamp2(java.sql.Timestamp[]) ';
select timestamp'5/5/2008 1:1:1 am' into x from db_root;
call ptesttimestamp2(x);
select x from db_root;


drop procedure ptesttimestamp2;
CREATE  Procedure  ptesttimestamp2(i out timestamp) as language java name 'SpTest5.ptesttimestamp2(java.sql.Timestamp[]) ';
select timestamp'5/5/2008 1:1:1 am' into x from db_root;
call ptesttimestamp2(x);
select x from db_root;


drop procedure ptesttimestamp2;
CREATE  Procedure  ptesttimestamp2(i timestamp) as language java name 'SpTest5.ptesttimestamp2(java.sql.Timestamp[]) ';
select timestamp'5/5/2008 1:1:1 am' into x from db_root;
call ptesttimestamp2(x);
select x from db_root;

drop procedure ptesttimestamp2;



rollback;


autocommit on;

