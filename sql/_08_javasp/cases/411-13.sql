autocommit off;

-- SET ����

create class xoo ( x set(int, string) );
insert into xoo values( {1,2,'3 ',4,5} );
insert into xoo values( {1,2,3 ,4,5} );
insert into xoo values( {} );
insert into xoo values( {null} );
insert into xoo values( null );
CREATE FUNCTION testset1(x set(int)) RETURN set(int) AS LANGUAGE JAVA NAME 'SpTest6.testset1(java.lang.Object[]) return java.lang.O
bject[]';
select testset1(x) from xoo order by 1;
drop function testset1;
drop table xoo;

create class xoo ( x set(string) );
insert into xoo values( {'1','','3 '} );
insert into xoo values( {'1','2','3' ,'4','5'} );
insert into xoo values( {} );
insert into xoo values( {null} );
insert into xoo values( null );
CREATE FUNCTION testset1(x set) RETURN set AS LANGUAGE JAVA NAME 'SpTest6.testset1(java.lang.Object[]) return java.lang.Object[]';
select testset1(x) from xoo;
drop function testset1;
drop table xoo;

create class xoo ( x sequence(string) );
insert into xoo values( {'1','','3 '} );
insert into xoo values( {'1','2','3' ,'4','5'} );
insert into xoo values( {} );
CREATE FUNCTION testset1(x sequence) RETURN sequence AS LANGUAGE JAVA NAME 'SpTest6.testset1(java.lang.Object[]) return java.lang.Object[]';
select testset1(x) from xoo;
drop function testset1;
drop table xoo;

create class xoo ( x multiset(string) );
insert into xoo values( {'1','','3 '} );
insert into xoo values( {'1','2','3' ,'4','5'} );
insert into xoo values( {} );
CREATE FUNCTION testset1(x multiset) RETURN multiset AS LANGUAGE JAVA NAME 'SpTest6.testset1(java.lang.Object[]) return java.lang.Object[]';
select testset1(x) from xoo;
drop function testset1;
drop table xoo;

create class xoo ( x set(string) );
insert into xoo values( {'1','','3 '} );
insert into xoo values( {'1','2','3' ,'4','5'} );
insert into xoo values( {} );
CREATE FUNCTION testset2(x set) RETURN set AS LANGUAGE JAVA NAME 'SpTest6.testset2(java.lang.String[]) return java.lang.String[]';
select testset2(x) from xoo;
drop function testset2;
drop table xoo;

create class xoo ( x set(string) );
insert into xoo values( {'1','','3 '} );
insert into xoo values( {'1','2','3' ,'4','5'} );
insert into xoo values( {} );
CREATE FUNCTION testset2(x set) RETURN set AS LANGUAGE JAVA NAME 'SpTest6.testset2(java.lang.String[]) return java.lang.String[]';
select testset2(x) from xoo;
drop function testset2;
drop table xoo;

create class xoo ( x set(int) );
insert into xoo values( {1,3 } );
insert into xoo values( {1,2,3 ,4,5} );
CREATE FUNCTION testset3(x set) RETURN set AS LANGUAGE JAVA NAME 'SpTest6.testset3(int[]) return int[]';
select testset3(x) from xoo;
drop table xoo;
drop function testset3;


create class xoo ( x set(int) );
insert into xoo values( {1,3 } );
insert into xoo values( {1,2,3 ,4,5} );
CREATE FUNCTION testset4(x set) RETURN set AS LANGUAGE JAVA NAME 'SpTest6.testset4(java.lang.Integer[]) return java.lang.Integer[]';
select testset4(x) from xoo;
drop table xoo;
drop function testset4;

-- set Ÿ�Կ� ���� inout ���� ����

create class xoo ( x set(int) );
insert into xoo values( {1,2,3,4,5} );
CREATE PROCEDURE testset5(x inout set) AS LANGUAGE JAVA NAME 'SpTest6.testset5(java.lang.Integer[][]) ';
select x into set1 from xoo;
call testset5(set1);
select set1 from db_root;
select t from table(set1) as tbl(t);

drop table xoo;
drop PROCEDURE testset5;
create class xoo ( x set(float) );
insert into xoo values( {1.1,2.1111,3.12345,400000,500000} );
CREATE PROCEDURE testset6(x inout set) AS LANGUAGE JAVA NAME 'SpTest6.testset6(java.lang.Float[][]) ';
select x into set1 from xoo;
call testset6(set1);
select set1 from db_root;
select t from table(set1) as tbl(t);

drop table xoo;
drop PROCEDURE testset6;
create class xoo ( x set(float) );
insert into xoo values( {1.1,2.1111,3.12345,400000,500000} );


CREATE PROCEDURE testset7(x inout set) AS LANGUAGE JAVA NAME 'SpTest6.testset7(java.lang.Float[][]) ';
select x into set1 from xoo;
call testset7(set1);
select set1 from db_root;
select t from table(set1) as tbl(t);

drop table xoo;
drop procedure testset7;

rollback;
autocommit on;

