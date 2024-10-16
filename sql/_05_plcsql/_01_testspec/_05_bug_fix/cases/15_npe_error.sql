--+ server-message on
-- verified the CBRD-25475
-- [bugfix] NPE occurs for incorrect JSP argument type specification

-- correct: create or replace procedure test_string(a String) as language java name 'Poo.test_string(java.lang.String)';
-- correct: CREATE or replace Procedure test_string(a string) as language java name 'SpTest5.pteststring1(java.lang.String) ';
CREATE or replace Procedure test_string(a string) as language java name 'SpTest5.pteststring1(String) ';

call test_string('aa');

drop procedure test_string;

--+ server-message off
