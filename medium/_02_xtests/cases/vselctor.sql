autocommit off;
create class xc (a int);
create class yc as subclass of xc;
create class zc (s string, x xc);
create vclass x as select * from xc;
create vclass y as subclass of x as select * from yc;
create vclass z (s string, x x) as select * from zc;
insert into x values (10) to x0;
insert into y values (20) to y0;
insert into z values ('x', x0);
insert into z values ('y', y0);
insert into x values (11) to x0;
insert into y values (22) to y0;
insert into z values ('x', x0);
insert into z values ('y', y0);
select z.x{x}.a from z,x;	
select z.x{y}.a from z,y order by 1;

-- Following sql statement is commented temporarily due to CUBRIDSUS4098 issues
--select z.x.a from z order by 1;	
select * from z,y where 0 <> z.xx{y}.a;
select * from z order by 1,2;
drop z, y, x;
drop yc;
drop xc, zc;
rollback;
