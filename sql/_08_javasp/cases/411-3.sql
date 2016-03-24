--+ holdcas on;

 CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt(int) return int';
 CREATE  FUNCTION test2(i int, j int) RETURN int as language java name 'SpTest.testInt(int, int) return int';
 CREATE  FUNCTION test3(i int, j string) RETURN int as language java name 'SpTest.testInt(int, string) return int';


create class xoo ( x int, y int);
insert into xoo values(1,11);
insert into xoo values(2,12);
insert into xoo values(3,13);
insert into xoo values(4,14);
insert into xoo values(5,15);

select  test1(x) bb from xoo where test1(xoo.x) < 100;
select  test1(x) bb from (select test1(y) x from xoo ) xx where test1(xx.x) < 100;
select  test1(x) bb from (select test1(y) x from xoo ) xx where test1(xx.x) < test1(100);
select  test1(x) bb from (select test1(y) x from xoo ) xx where test1(xx.x) = test1(xx.x);
select  test1(x) bb from (select test1(y) x from xoo ) xx where test1(xx.x) = test1(xx.x) ;
select  test1(xx.x) bb from xoo xx where xx.x = test1(xx.y) - 11 ;

update xoo set x = test1(x) -1 where y = test1(y) -1;
update xoo set x = test1(x);
update xoo set y = test1(x) - 1 - x + test1(y);
update xoo a set y = test1(x) + ( select test1(b.x) from xoo b where a.x = b.x) ;

select x from xoo;
select y from xoo;

update xoo set test1(x) = 10;
update (select x from xoo) a set a.x = 1;

delete from xoo where  test1(x) > 100;
delete from xoo where  100  < test1(x);
delete from xoo where test1(x + 10) < 100;
select x from xoo;

drop function test1;
drop function test3;
drop function test2;
drop table xoo;


commit;
--+ holdcas off;

