autocommit off;


create function select(i number, j string) return number 
as language java name 'SpTest.testInt(int,java.lang.String) return int';  
-- reserved word fail

create function function(i number, j string) return number 
as language java name 'SpTest.testInt(int,java.lang.String) return int';  
-- reserved word fail

create function int(i number, j string) return number 
as language java name 'SpTest.testInt(int,java.lang.String) return int';  
-- reserved word fail

create function language(i number, j string) return number 
as language java name 'SpTest.testInt(int,java.lang.String) return int';  
-- reserved word fail

create function test1(select number, insert string) return number 
as language java name 'SpTest.testInt(int,java.lang.String) return int';  
-- reserved word fail

rollback;
autocommit on;

