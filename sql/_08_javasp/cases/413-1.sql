-- type conversion

autocommit off;

CREATE  FUNCTION typetestbyte(i string) RETURN string as language java name 'SpTest2.typetestbyte(java.lang.String) return java.lang.Byte';
CREATE  FUNCTION typetestshort(i string) RETURN string as language java name 'SpTest2.typetestshort(java.lang.String) return java.lang.Short';
CREATE  FUNCTION typetestinteger(i string) RETURN string as language java name 'SpTest2.typetestinteger(java.lang.String) return java.lang.Integer';
CREATE  FUNCTION typetestlong(i string) RETURN string as language java name 'SpTest2.typetestlong(java.lang.String) return java.lang.Long';
CREATE  FUNCTION typetestfloat(i string) RETURN string as language java name 'SpTest2.typetestfloat(java.lang.String) return java.lang.Float';
CREATE  FUNCTION typetestdouble(i string) RETURN string as language java name 'SpTest2.typetestdouble(java.lang.String) return java.lang.Double';
CREATE  FUNCTION typetestbigdecimal(i string) RETURN string as language java name 'SpTest2.typetestbigdecimal(java.lang.String) return java.lang.BigDecimal';
CREATE  FUNCTION typetestshort1(i string) RETURN string as language java name 'SpTest2.typetestshort1(java.lang.String) return short';
CREATE  FUNCTION typetestlong1(i string) RETURN string as language java name 'SpTest2.typetestshort1(java.lang.String) return long';
CREATE  FUNCTION typetestfloat1(i string) RETURN string as language java name 'SpTest2.typetestfloat1(java.lang.String) return float';
CREATE  FUNCTION typetestdouble1(i string) RETURN string as language java name 'SpTest2.typetestdouble1(java.lang.String) return double';

call typetestbyte('111');
call typetestshort('111');
call typetestinteger('111');
call typetestshort1('111');
call typetestfloat('111');
call typetestdouble('111');
call typetestbigdecimal('111');
call typetestshort1('111');
call typetestlong1('111');
call typetestfloat1('111');
call typetestdouble1('111');

call typetestbyte(111);
call typetestshort(111);
call typetestinteger(111);
call typetestshort1(111);
call typetestfloat(111);
call typetestdouble(111);
call typetestbigdecimal(111);
call typetestshort1(111);
call typetestlong1(111);
call typetestfloat1(111);
call typetestdouble1(111);

call typetestbyte('xxx');
call typetestshort('xxx');
call typetestinteger('xxx');
call typetestshort1('xxx');
call typetestfloat('xxx');
call typetestdouble('xxx');
call typetestbigdecimal('xxx');
call typetestshort1('xxx');
call typetestlong1('xxx');
call typetestfloat1('xxx');
call typetestdouble1('xxx');

CREATE  FUNCTION typetestshort11(i string) RETURN string as language java name 'SpTest2.xxx(java.lang.String) return java.lang.Short';
call typetestshort11('111');

rollback;
autocommit on;

