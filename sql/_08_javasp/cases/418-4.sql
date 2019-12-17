--+ holdcas on;
autocommit off;

--  OID ����


CREATE  function  testoid1(i object) return object as language java name 'SpTest6.testoid1(cubrid.sql.CUBRIDOID) return cubrid.sql.CUBRIDOID';
CREATE  function  testoid2(i object) return string as language java name 'SpTest6.testoid2(cubrid.sql.CUBRIDOID) return java.lang.String';
CREATE  function  testoid3(x set) RETURN set AS LANGUAGE JAVA NAME 'SpTest6.testoid3(java.lang.Object[]) return java.lang.Object[]';
CREATE  function  testoid4(x string) RETURN object  AS LANGUAGE JAVA NAME 'SpTest6.testoid4(java.lang.String) return java.lang.Object';


create class xoo ( id int);
create class yoo ( xoo xoo);
create class zoo ( set1 set(xoo));


------ testoid1

insert into xoo values(1);
select xoo into oid1 from xoo where rownum = 1;
select * from xoo where xoo = testoid1(xoo);
update xoo set id = 100 where xoo = testoid1(xoo);
select * from xoo;
select testoid1(xoo) into x from xoo;
update object x set id = 1000;
select * from xoo;
select * from xoo where xoo = x;

call testoid1(oid1);
select testoid1(xoo) from xoo;

--select * from yoo;
insert into yoo select testoid1(xoo) from xoo;
--select xoo.id from yoo;
select testoid1(xoo) from xoo;

------ testoid2


select xoo.id from yoo;
call testoid2(oid1);
select testoid2(xoo) from xoo;
select count(*) from xoo;

------ testoid3, ptestoid3

CREATE procedure ptestoid3(x in out set, o object) AS LANGUAGE JAVA NAME 'SpTest6.ptestoid3(cubrid.sql.CUBRIDOID[][], cubrid.sql.CUBRIDOID) ';

insert into zoo values( { insert into xoo values(100), insert into xoo values(200) } );
select t.id from zoo , table(set1) as tbl(t) order by 1;
insert into zoo select testoid3(set1) from zoo;
select testoid3(set1 ) from zoo;
select t.id from zoo , table(set1) as tbl(t) order by 1;
select * from zoo where set1 seteq testoid3(set1);
select * from zoo where set1 in testoid3(set1);

delete from zoo;
insert into zoo values( { insert into xoo values(100), insert into xoo values(200) } );
insert into xoo values(300) into yyy;
select set1 into xxx from zoo;
select xoo into yyy from xoo where id = 300;
call ptestoid3(xxx, yyy);
select xxx from db_root;
select t.id from table(xxx) as tbl(t) order by 1;



------ testoid4
call testoid4('select xoo from xoo where id =100') into x;
select * from  xoo where xoo = x;
select * from xoo where xoo in ( select testoid4('select xoo from xoo where id = 100') from xoo);
select testoid3(set1) into xxx from zoo where rownum = 1;
select * from zoo where set1 in xxx;
select * from zoo where set1 in testoid3(set1);
select * from xoo where xoo in xxx order by 1;


------ ptestoid1, ptestoid2

CREATE procedure ptestoid1(i inout object, q string) as language java name 'SpTest6.ptestoid1(cubrid.sql.CUBRIDOID[], java.lang.String)';
CREATE procedure ptestoid2(i inout object) as language java name 'SpTest6.ptestoid2(cubrid.sql.CUBRIDOID[])';


create class xxoo ( id int);
create class yyoo ( id int);
insert into xxoo values(10);
insert into yyoo values(100000);

select xxoo into :xoid from xxoo where rownum = 1;
call ptestoid1(:xoid, 'select yyoo from yyoo');
select :xoid from db_root;
select * from yyoo where yyoo = :xoid;
select * from xxoo where xxoo = :xoid;

select xxoo into :xoid from xxoo where rownum = 1;
call ptestoid2(:xoid);
select :xoid from db_root;




drop function testoid1, testoid2, testoid3;
drop procedure  ptestoid1, ptestoid2;
drop table xoo,yoo, zoo;
drop table xxoo, yyoo;

rollback;

autocommit on;


--+ holdcas off;
