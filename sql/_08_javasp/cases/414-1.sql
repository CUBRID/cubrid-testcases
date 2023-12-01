-- 인자 갯수
--정상인 경우
CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt(int) return int';
drop function test1;

CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt() return int';
drop function test1;

CREATE  FUNCTION test1() RETURN int as language java name 'SpTest.testInt() return int';
drop function test1;

CREATE  FUNCTION test1() RETURN int as language java name 'SpTest.testInt(int) return int';
drop function test1;

-- 정상인 경우
CREATE  FUNCTION test1() RETURN int as language java name 'SpTest.testInt10() return int';
drop function test1;

CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt10() return int';
drop function test1;

CREATE  FUNCTION test1() RETURN int as language java name 'SpTest.testInt10(int) return int';
drop function test1;

CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt10(int) return int';
drop function test1;

