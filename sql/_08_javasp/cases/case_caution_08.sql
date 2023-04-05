CREATE OR REPLACE FUNCTION testresultset() RETURN STRING AS LANGUAGE JAVA NAME 'SpTest9.testresultset() RETURN java.lang.String';

create table ttbl (id int);
insert into ttbl values (1), (2), (3), (4);


CALL testresultset();

DROP TABLE ttbl;
DROP FUNCTION testresultset;
