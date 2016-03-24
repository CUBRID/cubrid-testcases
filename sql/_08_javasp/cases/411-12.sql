autocommit off;


--  integer ����


CREATE  Procedure  ptestinteger1(i inout int) as language java name 'SpTest5.ptestinteger1(java.lang.Integer) ';
select 10 into x from db_root;
call ptestinteger1(x);
call ptestinteger1('10');
call ptestinteger1('xx');
call ptestinteger1(null);
$integer,$10;
call ptestinteger1(?) ;
$varchar,$10;
call ptestinteger1(?) ;
drop procedure ptestinteger1;

CREATE  Procedure  ptestinteger1(i in int) as language java name 'SpTest5.ptestinteger1(java.lang.Integer) ';
select 10 into x from db_root;
call ptestinteger1(x);
call ptestinteger1('10');
call ptestinteger1('xx');
call ptestinteger1(null);
$integer,$10;
call ptestinteger1(?) ;
$varchar,$10;
call ptestinteger1(?) ;
drop procedure ptestinteger1;

CREATE  Procedure  ptestinteger1(i out int) as language java name 'SpTest5.ptestinteger1(java.lang.Integer) ';
select 10 into x from db_root;
call ptestinteger1(x);
call ptestinteger1('10');
call ptestinteger1('xx');
call ptestinteger1(null);
$integer,$10;
call ptestinteger1(?) ;
$varchar,$10;
call ptestinteger1(?) ;
drop procedure ptestinteger1;

CREATE  Procedure  ptestinteger1(i  int) as language java name 'SpTest5.ptestinteger1(java.lang.Integer) ';
select 10 into x from db_root;
call ptestinteger1(x);
call ptestinteger1('10');
call ptestinteger1('xx');
call ptestinteger1(null);
$integer,$10;
call ptestinteger1(?) ;
$varchar,$10;
call ptestinteger1(?) ;
drop procedure ptestinteger1;

CREATE  Procedure  ptestinteger2(i inout int) as language java name 'SpTest5.ptestinteger2(java.lang.Integer[]) ';

select 10 into x from db_root;
call ptestinteger2(x);
select x from db_root;
call ptestinteger2('10');
call ptestinteger2('xx');
call ptestinteger2(null);
$integer,$10;
call ptestinteger2(?) ;
$varchar,$10;
call ptestinteger2(?) ;
drop procedure ptestinteger2;

CREATE  Procedure  ptestinteger2(i out int) as language java name 'SpTest5.ptestinteger2(java.lang.Integer[]) ';

select 10 into x from db_root;
call ptestinteger2(x);
select x from db_root;
call ptestinteger2('10');
call ptestinteger2('xx');
call ptestinteger2(null);
$integer,$10;
call ptestinteger2(?) ;
$varchar,$10;
call ptestinteger2(?) ;
drop procedure ptestinteger2;

CREATE  Procedure  ptestinteger2(i  int) as language java name 'SpTest5.ptestinteger2(java.lang.Integer[]) ';

select 10 into x from db_root;
call ptestinteger2(x);
select x from db_root;
call ptestinteger2('10');
call ptestinteger2('xx');
call ptestinteger2(null);
$integer,$10;
call ptestinteger2(?) ;
$varchar,$10;
call ptestinteger2(?) ;
drop procedure ptestinteger2;

CREATE  Procedure  ptestinteger3(i inout int) as language java name 'SpTest5.ptestinteger3(java.lang.Integer[]) ';

select 10 into x from db_root;
call ptestinteger3(x);
select x from db_root;
call ptestinteger3('10');
call ptestinteger3('xx');
call ptestinteger2(null);
$integer,$10;
call ptestinteger3(?) ;
$varchar,$10;
call ptestinteger3(?) ;
drop procedure ptestinteger3;


rollback;

autocommit on;

