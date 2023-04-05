CREATE OR REPLACE FUNCTION testcreateBlob() RETURN STRING AS LANGUAGE JAVA NAME 'SpTest9.testblob() RETURN java.lang.String';

CALL testcreateBlob();

DROP FUNCTION testcreateBlob;
