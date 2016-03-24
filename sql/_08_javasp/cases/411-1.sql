autocommit off;

 CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt(int) return int';
 CREATE  FUNCTION test2(i int, j int) RETURN int as language java name 'SpTest.testInt(int, int) return int';
 CREATE  FUNCTION test3(i int, j string) RETURN int as language java name 'SpTest.testInt(int, java.lang.String) return int';



create class xoo ( id int auto_increment primary key, x int, y int);
insert into xoo (x,y) values(1,2);
insert into xoo (x,y) values(2,2);
insert into xoo (x,y) values(3,3);
insert into xoo (x,y) values(4,4);

select test1(4) from db_root;

$integer,$4;
insert into xoo (x,y) values(5,test1(?)) ;
insert into xoo (x,y) select x + 5, x from xoo order by id asc;

insert into xoo (x,y) select test1(x) , test1(x) + 10 from xoo order by id asc;
insert into xoo (x,y) select test1(b.x), (select test1(a.x) from xoo a where a.x = b.x and rownum = 1) from xoo b order by id asc;

call test1(100);
call test1(null);
call test1((select 1 from db_root));
select test1(x) from xoo order by id asc;
select test1(x) from xoo where test1(x) < 100 order by id asc;
select test1(x) + test1(x) from xoo order by id asc;

$out:integer,$NULL;
? = call test1(100) ;
$out:integer,$NULL,$integer,$100;
? = call test1(?) ;

call test2(100, 100);
call test3(100, '100');

$out:integer,$NULL;
? = call test2(100, 100) ;
$out:integer,$NULL,$integer,$100,$integer,$100;
? = call test2(?,?) ;

$out:integer,$NULL;
? = call test3(100, '100') ;
$out:integer,$NULL,$integer,$100,$varchar,$100;
? = call test3(?,?) ;

 drop function test1;
 drop function test3;
 drop function test2;
drop table xoo;

rollback;

autocommit on;

