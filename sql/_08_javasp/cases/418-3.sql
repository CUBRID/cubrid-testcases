autocommit off;

CREATE  FUNCTION typetestint( i monetary ) RETURN monetary as language java name 'SpTest7.typetestint(int) return int';
CREATE  FUNCTION typetestinteger( i monetary ) RETURN monetary as language java name 'SpTest7.typetestinteger(java.lang.Integer) return java.lang.Integer';
CREATE  FUNCTION typeteststring( i monetary ) RETURN monetary as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';
CREATE  FUNCTION typetestshort( i monetary ) RETURN monetary as language java name 'SpTest7.typetestshort(java.lang.Short) return java.lang.Short';
CREATE  FUNCTION typetestlong( i monetary ) RETURN monetary as language java name 'SpTest7.typetestlong(java.lang.Long) return java.lang.Long';
CREATE  FUNCTION typetestfloat( i monetary ) RETURN monetary as language java name 'SpTest7.typetestfloat(java.lang.Float) return java.lang.Float';
CREATE  FUNCTION typetestdouble( i monetary ) RETURN monetary as language java name 'SpTest7.typetestdouble(java.lang.Double) return java.lang.Double';
CREATE  FUNCTION typetestbigdecimal( i monetary ) RETURN monetary as language java name 'SpTest7.typetestbigdecimal(java.math.BigDecimal) return java.math.BigDecimal';
CREATE  FUNCTION typetestshort1( i monetary ) RETURN monetary as language java name 'SpTest7.typetestshort1(short) return short';
CREATE  FUNCTION typetestlong1( i monetary ) RETURN monetary as language java name 'SpTest7.typetestlong1(long) return long';
CREATE  FUNCTION typetestfloat1( i monetary ) RETURN monetary as language java name 'SpTest7.typetestfloat1(float) return float';
CREATE  FUNCTION typetestdouble1( i monetary ) RETURN monetary as language java name 'SpTest7.typetestdouble1(double) return double';

create class xoo ( cost monetary );
insert into xoo values(0);
insert into xoo values(20);

call typetestint(0);
call typetestint(20);
select  typetestint(20) from xoo ;
select  typetestint(cost) from xoo ;
$out:integer,$NULL,$integer,$20;
? = call typetestint(?) ;

call typetestinteger(0);
call typetestinteger(20);
select  typetestinteger(20) from xoo ;
select  typetestinteger(cost) from xoo ;
$out:integer,$NULL,$integer,$20;
? = call typetestinteger(?) ;

call typeteststring('0');
call typeteststring('20');
select  typeteststring('20') from xoo ;
select  typeteststring(cost) from xoo ;
$out:integer,$NULL,$varchar,$20;
? = call typeteststring(?) ;

call typetestshort(0);
call typetestshort(20);
select  typetestshort(20) from xoo ;
select  typetestshort(cost) from xoo ;
$out:integer,$NULL,$integer,$20;
? = call typetestshort(?) ;

call typetestlong(0);
call typetestlong(20);
select  typetestlong(20) from xoo ;
select  typetestlong(cost) from xoo ;
$out:integer,$NULL,$integer,$20;
? = call typetestlong(?) ;

call typetestfloat(0);
call typetestfloat(20);
select  typetestfloat(20) from xoo ;
select  typetestfloat(cost) from xoo ;
$out:integer,$NULL,$integer,$20;
? = call typetestfloat(?) ;

call typetestdouble(0);
call typetestdouble(20);
select  typetestdouble(20) from xoo ;
select  typetestdouble(cost) from xoo ;
$out:integer,$NULL,$integer,$20;
? = call typetestdouble(?) ;

call typetestbigdecimal(0);
call typetestbigdecimal(20);
select  typetestbigdecimal(20) from xoo ;
select  typetestbigdecimal(cost) from xoo ;
$out:integer,$NULL,$integer,$20;
? = call typetestbigdecimal(?) ;

call typetestshort1(0);
call typetestshort1(20);
select  typetestshort1(20) from xoo ;
select  typetestshort1(cost) from xoo ;
$out:integer,$NULL,$integer,$20;
? = call typetestshort1(?) ;

call typetestlong1(0);
call typetestlong1(20);
select  typetestlong1(20) from xoo ;
select  typetestlong1(cost) from xoo ;
$out:integer,$NULL,$integer,$20;
? = call typetestlong1(?) ;

call typetestfloat1(0);
call typetestfloat1(20);
select  typetestfloat1(20) from xoo ;
select  typetestfloat1(cost) from xoo ;
$out:integer,$NULL,$integer,$20;
? = call typetestfloat1(?) ;

call typetestdouble1(0);
call typetestdouble1(20);
select  typetestdouble1(20) from xoo ;
select  typetestdouble1(cost) from xoo ;
$out:integer,$NULL,$integer,$20;
? = call typetestdouble1(?) ;


CREATE  procedure ptypetestint( i inout monetary )  as language java name 'SpTest7.ptypetestint(int[]) ';
CREATE  procedure ptypetestinteger( i inout monetary ) as language java name 'SpTest7.ptypetestinteger(java.lang.Integer[]) ';
CREATE  procedure ptypeteststring( i  inout monetary )  as language java name 'SpTest7.ptypeteststring(java.lang.String[])' ;
CREATE  procedure ptypetestshort( i  inout monetary ) as language java name 'SpTest7.ptypetestshort(java.lang.Short[])' ;
CREATE  procedure ptypetestlong( i  inout monetary ) as language java name 'SpTest7.ptypetestlong(java.lang.Long[])';
CREATE  procedure ptypetestfloat( i  inout monetary ) as language java name 'SpTest7.ptypetestfloat(java.lang.Float[]) ';
CREATE  procedure ptypetestdouble( i  inout monetary )  as language java name 'SpTest7.ptypetestdouble(java.lang.Double[])';
CREATE  procedure ptypetestbigdecimal( i  inout monetary ) as language java name 'SpTest7.ptypetestbigdecimal(java.math.BigDecimal[])';
CREATE  procedure ptypetestshort1( i  inout monetary )  as language java name 'SpTest7.ptypetestshort1(short[]) ';
CREATE  procedure ptypetestlong1( i  inout monetary )  as language java name 'SpTest7.ptypetestlong1(long[]) ';
CREATE  procedure ptypetestfloat1( i  inout monetary )  as language java name 'SpTest7.ptypetestfloat1(float[]) ';
CREATE  procedure ptypetestdouble1( i  inout monetary )  as language java name 'SpTest7.ptypetestdouble1(double[])';

select 0 into x from db_root;
call ptypetestint(x);
select x from db_root;
call ptypetestint(20);
select ptypetestint(20) from xoo ;
select  ptypetestint(cost) from xoo ;
$integer,$20;
call ptypetestint(?) ;

select 0 into x from db_root;
call ptypetestinteger(x);
select x from db_root;
call ptypetestinteger(20);
select ptypetestinteger(20) from xoo ;
select  ptypetestinteger(cost) from xoo ;
$integer,$20;
call ptypetestinteger(?) ;

select '0' into x from db_root;
call ptypeteststring(x);
select x from db_root;
call ptypeteststring('20');
select ptypeteststring('20') from xoo ;
select  ptypeteststring(cost) from xoo ;
$integer,$20;
call ptypeteststring(?) ;

select 0 into x from db_root;
call ptypetestshort(x);
select x from db_root;
call ptypetestshort(20);
select ptypetestshort(20) from xoo ;
select  ptypetestshort(cost) from xoo ;
$integer,$20;
call ptypetestshort(?) ;

select 0 into x from db_root;
call ptypetestlong(x);
select x from db_root;
call ptypetestlong(20);
select ptypetestlong(20) from xoo ;
select  ptypetestlong(cost) from xoo ;
$integer,$20;
call ptypetestlong(?) ;

select 0 into x from db_root;
call ptypetestfloat(x);
select x from db_root;
call ptypetestfloat(20);
select ptypetestfloat(20) from xoo ;
select  ptypetestfloat(cost) from xoo ;
$integer,$20;
call ptypetestfloat(?) ;

select 0 into x from db_root;
call ptypetestdouble(x);
select x from db_root;
call ptypetestdouble(20);
select ptypetestdouble(20) from xoo ;
select  ptypetestdouble(cost) from xoo ;
$integer,$20;
call ptypetestdouble(?) ;

select 0 into x from db_root;
call ptypetestbigdecimal(x);
select x from db_root;
call ptypetestbigdecimal(20);
select ptypetestbigdecimal(20) from xoo ;
select  ptypetestbigdecimal(cost) from xoo ;
$integer,$20;
call ptypetestbigdecimal(?) ;

select 0 into x from db_root;
call ptypetestshort1(x);
select x from db_root;
call ptypetestshort1(20);
select ptypetestshort1(20) from xoo ;
select  ptypetestshort1(cost) from xoo ;
$integer,$20;
call ptypetestshort1(?) ;

select 0 into x from db_root;
call ptypetestlong1(x);
select x from db_root;
call ptypetestlong1(20);
select ptypetestlong1('20') from xoo ;
select  ptypetestlong1(cost) from xoo ;
$integer,$20;
call ptypetestlong1(?) ;

select 0 into x from db_root;
call ptypetestfloat1(x);
select x from db_root;
call ptypetestfloat1(20);
select ptypetestfloat1(20) from xoo ;
select  ptypetestfloat1(cost) from xoo ;
$integer,$20;
call ptypetestfloat1(?) ;

select 0 into x from db_root;
call ptypetestdouble1(x);
select x from db_root;
call ptypetestdouble1(20);
select ptypetestdouble1(20) from xoo ;
select  ptypetestdouble1(cost) from xoo ;
$integer,$20;
call ptypetestdouble1(?) ;

rollback;             

autocommit on;

