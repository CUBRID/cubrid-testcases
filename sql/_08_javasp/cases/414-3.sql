-- 인자 타입
CREATE  FUNCTION test1(i varchar) RETURN int as language java name 'SpTest.testInt(int) return int';
drop function test1;

CREATE  FUNCTION test1(i varchar) RETURN int as language java name 'SpTest.testInt(int)';
drop function test1;

CREATE  FUNCTION test1(i varchar)  as language java name 'SpTest.testInt(int) return int';



-- java 
CREATE  FUNCTION test1(i varchar) RETURN int as language java name 'SpTest.test123131Int(int) return int';
drop function test1;

CREATE  FUNCTION test1(i varchar) RETURN int as language java name 'SpTest1213.test123131Int(int) return int';
drop function test1;

