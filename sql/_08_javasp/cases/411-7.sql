--+ holdcas on;
autocommit off;


CREATE  FUNCTION typeteststring2() RETURN string as language java name 'SpTest3.typeteststring1() return java.lang.String';
$out:varchar,$NULL;
? = call typeteststring2() ;

CREATE  FUNCTION typeteststring3() RETURN int as language java name 'SpTest3.typeteststring3() return java.lang.String';
$out:integer,$NULL;
? = call typeteststring3() ;

CREATE Procedure ptestint3(i inout int) as language java name 'SpTest5.ptestint1(int) '; 
select 1 into x from db_root;
call ptestint3(x);

CREATE  Procedure  ptestdate2(i inout date) as language java name 'SpTest5.ptestdate2(java.sql.Date[]) ';
 select date'5/5/2008' into x from db_root;
call ptestdate2(x);
select x from db_root;


CREATE  Procedure  ptesttime3(i inout time) as language java name 'SpTest5.ptesttime3(java.sql.Time[]) ';
select time'1:1:1 am' into x from db_root;
call ptesttime3(x);
$out:time,$NULL;
? =  call ptesttime3(x) ;
select x from db_root;


call x1();

call x1();

CREATE  FUNCTION typeteststring1() RETURN int as language java name 'SpTest3.typeteststring1() return java.lang.String';
$out:integer,$NULL;
? = call typeteststring1() ;



rollback;

autocommit on;


--+ holdcas off;
