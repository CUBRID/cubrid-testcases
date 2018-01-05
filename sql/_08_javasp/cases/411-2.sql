 CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt(int) return int';
 CREATE  FUNCTION test2(i int, j int) RETURN int as language java name 'SpTest.testInt(int, int) return int';
 CREATE  FUNCTION test3(i int, j string) RETURN int as language java name 'SpTest.testInt(int, string) return int';


drop function xxxx;

drop procedure xxxx;

create class xoo ( x int, y int);
insert into xoo values(1,11);
insert into xoo values(2,12);
insert into xoo values(3,13);
insert into xoo values(4,14);
insert into xoo values(5,15);
insert into xoo values(test1(6), 16);
insert into xoo values(test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(1)))))))))))), 17);

$integer,$10;
call test1(?) ;
$integer,$10;
call test1(?) ;
$out:integer,$NULL,$integer,$10;
? = call test1(?) ;
$integer,$10;
call test1(?) ;


call test1(100);
select test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y) from xoo order by 1;
select test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y) from xoo where x = 1 order by 1;
select test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y) from xoo where x = 2 order by 1;
select test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y) from xoo where x = 3 order by 1;
select test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y) from xoo where x = 4 order by 1;
select test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y), test1(x), test1(y) from xoo where x = 5 order by 1;
select test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(x)))))))))))) from xoo order by 1;
select  test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(x)))))))))))) from xoo where  test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(test1(x)))))))))))) < 100 order by 1;
select test1(x) from xoo where test1(x) < 100 order by 1;
select test1(x) + 110  from xoo where test1(x) + 110 < 110 order by 1;
select test1(x) + 50  from xoo where test1(x) + x < 100 order by 1;
select test1(x) + test1(x) from xoo order by 1;
select test1(a.x), test1(b.x) from xoo a, xoo b order by 1,2;
select test1(a.x) from xoo a, ( select test1(x) from xoo) b order by 1;
select test1(b.xx) from ( select test1(x)+test1(y) xx from xoo) b order by 1;
select test1(b.xx) xx, test1(c.yy) yy from ( select test1(x)+test1(y) xx from xoo) b,  ( select test1(x)+test1(y) yy from xoo) c order by 1,2;
select  (select test1(b.x) from xoo b  where a.x = b.x)    from xoo a order by 1;
select  (select    (select test1(c.x) from xoo c where c.x = b.x)  from xoo b  where a.x = b.x)    from xoo a order by 1;


drop function test1;
drop function test3;
drop function test2;
drop table xoo;


