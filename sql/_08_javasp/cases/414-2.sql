-- 인자 타입
CREATE  FUNCTION test1(i varchar) RETURN number as language java name 'SpTest.testInt(int) return int';
drop function test1;

create  FUNCTION test1(i number) RETURN number as language java name 'SpTest.testInt(int) return int';
drop function test1;

CREATE  FUNCTION test1(i varchar) RETURN varchar as language java name 'SpTest.testInt(int) return int';
drop function test1;

CREATE  FUNCTION test1(i number) RETURN varchar as language java name 'SpTest.testInt(int) return int';
drop function test1;

CREATE  FUNCTION test1(i varchar) RETURN number as language java name 'SpTest.testInt(java.lang.String) return int';
drop function test1;

CREATE  FUNCTION test1(i number) RETURN number as language java name 'SpTest.testInt(java.lang.String) return int';
drop function test1;

CREATE  FUNCTION test1(i varchar) RETURN varchar as language java name 'SpTest.testInt(java.lang.String) return int';
drop function test1;

CREATE  FUNCTION test1(i number) RETURN varchar as language java name 'SpTest.testInt(java.lang.String) return int';
drop function test1;

