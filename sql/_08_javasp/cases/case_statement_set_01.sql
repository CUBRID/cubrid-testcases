--This is a test case to verify the use of character set operators with javasp functions. (UNION, DIFFERENCE, INTERSECTION)

CREATE OR REPLACE FUNCTION test_fc(i int) RETURN int as language java name 'SpTest.testInt(int) return int';
CREATE OR REPLACE FUNCTION test_fc2(i double) RETURN double as language java name 'SpTest.testDouble(double) return double';
CREATE OR REPLACE FUNCTION test_fc3(i string) RETURN string as language java name 'SpTest.Hello(java.lang.String) return java.lang.String';

-- int-int
select test_fc(1) 
union select test_fc(1) ;

select test_fc(1) 
difference select test_fc(1) ;

select test_fc(1) 
intersection select test_fc(1) ;

-- int-double
select test_fc(1)
union select test_fc2(1) ;

select test_fc(1)
difference select test_fc2(1) ;

select test_fc(1)
intersection select test_fc2(1) ;

-- string-string
select test_fc3('Cubrid')
union select test_fc3('Cubrid') ;

select test_fc3('Cubrid')
difference select test_fc3('Cubrid') ;

select test_fc3('Cubrid')
intersection select test_fc3('Cubrid') ;


drop FUNCTION test_fc;
drop FUNCTION test_fc2;
drop FUNCTION test_fc3;
