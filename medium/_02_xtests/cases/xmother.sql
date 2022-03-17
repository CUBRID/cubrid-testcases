--+ holdcas on;
autocommit off;
create class x (xint int, xstr string, class cint int)
	method ambiguous(int, int) int
		function add_int,
               concat_str(string, string) string
                function concat_str,
	       self() x
		function get_self,
	       add_int(int, int) int
		function add_int,
               class num_in_class() int
                function num_in_class,
	       class add_class_int(int, int) int
		function add_int
	file	'$METHOD_FILE';
create class x2 (xint int, xstr string, class cint int)
        method x_recurse(int) int
	        function x_recurse,
	       esqlx_add_int(int) int
		function esqlx_add_int
	file	'$RECURSE_FILE', '$LIB_FILE';
create class y (yint int, ystr string, to_x x)
	method y_self() y
		function get_self,
               ambiguous(int, int) int
		function mul_int,
	       add_int(int, int) int
		function add_int,
               concat_str(string, string) string
		function concat_str,
               class y_num_in_class() int
                function num_in_class
	file '$METHOD_FILE';
create class z (zint int, xs sequence(x))
	method same_seq(sequence(x)) sequence(x)
		function same_seq
	file '$METHOD_FILE';
create vclass v_x (v_xint int, v_xstr string)
	method ambiguous(int, int) int
		function mul_int,
               concat_str(string, string) string
                function concat_str,
	       view_method(int) int
                function sub_one,
               self() x
		function get_self,
	       add_int(int, int) int
		function add_int,
               class num_in_class() int
                function num_in_class
	file '$METHOD_FILE'
	as select xint, xstr from x where xint <> 2;
create vclass computed_x (vcomp_int int)
	method add_int(int, int) int
                function add_int
	file '$METHOD_FILE'
	as select xint*2 from x where xstr > 'string 1';
create vclass union_xy (vunion_int int, vunion_str string)
        method concat_str(string, string) string
                function concat_str
	file '$METHOD_FILE'
	as (select xint, xstr from x where xint > 1 
            union
            select yint, ystr from y where yint < 40);
create vclass diff_xy (vdiff_int int, vdiff_str string)
        method concat_str(string, string) string
                function concat_str
	file '$METHOD_FILE'
	as (select xint, xstr from x where xint > 1
            difference
            select yint, ystr from y where yint < 40);
create vclass inter_xy (vinter_int int, vinter_str string)
        method concat_str(string, string) string
                function concat_str
	file '$METHOD_FILE'
	as (select xint, xstr from x where xint > 1 
            intersection
            select yint, ystr from y where yint < 40);
create vclass meth_x (meth_int int, meth_str string)
        method concat_str(string, string) string
                function concat_str,
	       ambiguous(int, int) int 
                function mul_int
	file '$METHOD_FILE'
	as select ambiguous(x, xint, 20),concat_str(x, xstr, '**VIEW**') from x
	   where xint > 1;
create class x_son as subclass of x
	method ambiguous(int, int) int
		function mul_int
	file '$METHOD_FILE';
create class xy_son as subclass of x, y
	inherit ambiguous of y,
	        ambiguous of x as xy_add_int,
		concat_str of x,
		add_int of x;
create class x_1 as subclass of x;
delete from x;
insert into x values (1, 'string 1');
insert into x values (2, 'string 2');
insert into x values (3, 'string 3');
insert into x values (4, 'string 4');
insert into x values (5, 'string 5');
delete from y;
insert into y(yint, ystr) values (10, 'string 10');
insert into y(yint, ystr) values (20, 'string 20');
insert into y(yint, ystr) values (30, 'string 30');
insert into y(yint, ystr) values (40, 'string 40');
insert into y(yint, ystr) values (50, 'string 50');
select x into p1 from x where xint = 4;
call add_int(p1, 1, 2);
call add_int(1, 2) on p1;
call num_in_class() on class x;
call num_in_class(class x);
call num_in_class() on class v_x;
call num_in_class(class v_x);
call add_int(4, 10) on (select x from x where xint = 3);
call add_int(4, 10) on (select x from x where add_int(x, xint, 1) = 3);
call add_int(4, (select add_int(y, yint, xint) 
		 from y,  (select xint from x where xint = yint/10) as t(xint)
		 where concat_str(y, ystr, '***') = 
			concat_str(y, 'string 10','***')))
     on (select x from x where add_int(x, xint, 1) = 3);
delete from x;
insert into x values (1, 'string 1');
insert into x values (2, 'string 2');
insert into x values (3, 'string 3');
insert into x values (4, 'string 4');
insert into x values (5, 'string 5');
update class x set cint = 1111;
delete from y;
insert into y(yint, ystr) values (10, 'string 10');
insert into y(yint, ystr) values (20, 'string 20');
insert into y(yint, ystr) values (30, 'string 30');
insert into y(yint, ystr) values (40, 'string 40');
insert into y(yint, ystr) values (50, 'string 50');
select y_num_in_class(class y), y.yint from y order by 2;
select y_num_in_class(class y) from class y;
select y_num_in_class(class y) from y;
select y_num_in_class(class y), add_int(y, yint, 5) from y order by 2;
select add_int(y, yint, y_num_in_class(class y)) from y order by 1;
select y_num_in_class() on class y from x;
select y_num_in_class() on class y, xint from x order by 2;
select xint, yint, add_int(y, xint+4, yint/2) from 
   y, x
where xint < num_in_class(class x)
 and yint > (select yint from 
		(select yint from y 
                 where yint = add_int(y,10,10)) as t(yint)
             where yint = 20) order by 1, 2;
select add_class_int(class x, cint, 4) from class x;
select num_in_class(tobj) from (select class x from class x) as t(tobj);
delete from x;
insert into x values (1, 'string 1');
insert into x values (2, 'string 2');
insert into x values (3, 'string 3');
insert into x values (4, 'string 4');
insert into x values (5, 'string 5');
delete from y;
insert into y(yint, ystr) values (10, 'string 10');
insert into y(yint, ystr) values (20, 'string 20');
insert into y(yint, ystr) values (30, 'string 30');
insert into y(yint, ystr) values (40, 'string 40');
insert into y(yint, ystr) values (50, 'string 50');
select x into p1 from x where xint = 4;
evaluate add_int(p1, 1, 2);
evaluate add_int(1, 2) on p1;
evaluate num_in_class() on class x;
evaluate num_in_class(class x);
evaluate num_in_class() on class v_x;
evaluate num_in_class(class v_x);
evaluate add_int(4, 10) on (select x from x where xint = 3);
evaluate add_int(4, 10) on (select x from x where add_int(x, xint, 1) = 3);
evaluate add_int(4, (select add_int(y, yint, xint) 
		 from y,  (select xint from x where xint = yint/10) as t(xint)
		 where concat_str(y, ystr, '***') = 
			concat_str(y, 'string 10','***')))
     on (select x from x where add_int(x, xint, 1) = 3);
evaluate (select add_int(y, xint+4, yint/2) from 
   y, x
where xint = 2 and yint = (select yint from 
				(select yint from y 
                                 where yint = add_int(y,10,10)) as t(yint)
                            where yint = 20));
delete from x;
insert into x values (1, 'string 1');
insert into x values (2, 'string 2');
insert into x values (3, 'string 3');
insert into x values (4, 'string 4');
insert into x values (5, 'string 5');
delete from x_son;
insert into x_son values (11, 'string 11');
insert into x_son values (22, 'string 22');
insert into x_son values (33, 'string 33');
insert into x_son values (44, 'string 44');
insert into x_son values (55, 'string 55');
delete from y;
insert into y(yint, ystr) values (100, 'string 100');
insert into y(yint, ystr) values (200, 'string 200');
insert into y(yint, ystr) values (300, 'string 300');
insert into y(yint, ystr) values (400, 'string 400');
insert into y(yint, ystr) values (500, 'string 500');
delete from xy_son;
insert into xy_son(xint, xstr, yint, ystr)  values (111, 'string 111', 101, 'string 101');
insert into xy_son(xint, xstr, yint, ystr) values (222, 'string 222', 202, 'string 202');
insert into xy_son(xint, xstr, yint, ystr) values (333, 'string 333', 303, 'string 303');
insert into xy_son(xint, xstr, yint, ystr) values (444, 'string 444', 404, 'string 404');
insert into xy_son(xint, xstr, yint, ystr) values (555, 'string 555', 505, 'string 505');
select ambiguous(x, xint, 5), concat_str(x, xstr, '***') from x order by 1;
select ambiguous(y, yint, 5), concat_str(y, ystr, '***') from y order by 1;
select ambiguous(x_son, xint, 5), concat_str(x_son, xstr, '***') from x_son order by 1;
select ambiguous(xy_son, xint, 5), xy_add_int(xy_son, yint, 5), 
       concat_str(xy_son, xstr, '***') from xy_son order by 1;
select ambiguous(x, xint, 5) from all x order by 1;
select ambiguous(x, x.xint, 6), xy_add_int(xy_son, xy_son.xint, 7) 
from all x (except xy_son), xy_son order by 1, 2;
delete from x2;
insert into x2 values (1, 'x string 1') to p1;
insert into x2 values (2, 'x string 2') to p2;
insert into x2 values (3, 'x string 3') to p3;
insert into x2 values (4, 'x string 4') to p4;
select x_recurse(x2, 0) from x2;
select x_recurse(x2, 1) from x2;
select x_recurse(x2, 2) from x2;
select x_recurse(x2, 3) from x2;
select x_recurse(x2, 4) from x2;
delete from x;
insert into x values (1, 'string 1') into x1;
insert into x values (2, 'string 2') into x2;
insert into x values (3, 'string 3') into x3;
insert into x values (4, 'string 4');
insert into x values (5, 'string 5');
delete from y;
insert into y(yint, ystr) values (10, 'string 10');
insert into y(yint, ystr) values (20, 'string 20');
insert into y(yint, ystr) values (30, 'string 30');
insert into y(yint, ystr) values (40, 'string 40');
insert into y(yint, ystr) values (50, 'string 50');
delete from z;
insert into z values (123, {x1, x2, x3});
insert into z values (321, {x3, x2, x1});
insert into z values (13, {x1, x3});
select add_int(xint1, (select yint from y where yint = 10)) 
       on (select x from x where xint = 4), 
       (select yint from y where yint = add_int(y, 30, 10)) 
from (select self(x), xint from x where add_int(x, xint, 1) > 2) 
     as t(x1, xint1)
where add_int(xint1, (select xint from x where xint = 3))
    on (select y from y where yint = 40) > 
	(select xint from x where xint = add_int(x, 2, 3)) order by 1;
select add_int(xint1, (select yint from y where yint/10 = xint1)) 
       on (select x from x where xint = xint1), 
       (select yint from y where yint/10 + 10 = add_int(x1, xint1, 10)),
       xint2
from (select self(x), xint from x where add_int(x, xint, 1) > 2) 
     as t(x1, xint1),
     (select xint from x where add_int(x, xint, 5) = add_int(x1, xint1, 5)) 
     as t2(xint2)
where add_int(xint1, (select xint from x where xint = xint1))
    on (select y from y where yint/10 = xint1) > 
	(select xint+add_int(x, xint1, -2) from x where xint = xint1) order by 1;
select add_int(xint1, (select yint from y where yint/10 = 5)) 
       on (select x from x where xint = xint1), 
       (select yint from y where yint/10 + 10 = add_int(x1, xint1, 10)),
       xint2
from (select self(x), xint from x where add_int(x, xint, 1) > 2) 
     as t(x1, xint1),
     (select xint from x where add_int(x, xint, 5) = add_int(x1, xint1, 5)) 
     as t2(xint2)
where add_int(xint1, (select xint from x where xint = add_int(x, 1,3)))
    on (select y from y where yint/10 = add_int(y, 4, 0)) > 
	(select xint+add_int(x, xint1, -2) from x 
           where xint = xint1+add_int(x1, 2,3) - add_int(x, 3, 2)) + 1 order by 1;
select add_int(xint1, (select yint from y where yint/10 = 5)) 
       on (select x from x where xint = xint1), 
       (select yint from y where yint/10 + 10 = add_int(x1, xint1, 10)),
       add_int(yint1, (select xint from x where xint*10 = yint1))
       on (select y from y where yint = yint1)
from (select self(x), xint from x where add_int(x, xint, 1) > 2) 
     as t(x1, xint1),
     (select y_self(y), yint from y where add_int(y, yint, yint) < 90)
     as t2(y1, yint1)
where add_int(xint1, (select xint from x where xint = add_int(x, 1,3))) 
      on y_self(y1) > 
	(select xint+add_int(x, xint1, -2) from x 
           where xint = xint1+add_int(x1, 2,3) - add_int(x, 3, 2)) + 1
 and add_int(y_self(y1), yint1, 4) > 20 order by 1, 2, 3;
select add_int(xint1, (select yint from y where yint/10 = 5)) 
       on (select x from x where xint = xint1), 
       (select yint from y where yint/10 + 10 = add_int(x1, xint1, 10)),
       add_int(yint1, (select xint1 from x where xint*10 = yint1))
       on (select y from y where yint = yint1)
from (select self(x), xint from x where add_int(x, xint, 1) > 2) 
     as t(x1, xint1),
     (select y_self(y), yint from y where add_int(y, yint, yint) < 90)
     as t2(y1, yint1)
where add_int(xint1, (select xint from x where xint = add_int(x, 1,3))) 
      on y_self(y1) > 
	(select xint+add_int(x, xint1, -2) from x 
           where xint = xint1+add_int(x1, 2,3) - add_int(x, 3, 2)) + 1
 and add_int(y_self(y1), xint1, yint1) > 20 order by 1, 2, 3;
select add_int(y_self(y_self(y_self(y_self(y_self(y))))), yint, yint) from y order by 1;
select add_int(xint1, 
	       (select yint1 from 
                  (select yint from y where yint = 10) as t(yint1) 
                where yint1 = 10)) 
       on (select (select x from x where xint = 3) from x where xint = 4), 
       (select yint from y where (select yint from y where yint = 40)
				  = y_self(y).yint) 
from (select self(x), xint from x where add_int(x, xint, 1) > 
			(select 2 from y where yint = add_int(y, 40, 10)))
     as t(x1, xint1)
where add_int(xint1, (select xint2 from 
		         (select xint from x 
		          where add_int(self(x), xint, 0) = 3) as t(xint2)
		       where xint2 = 3))
   on (select y from y where (select yint+10 from y where yint = 30) = yint) > 
	(select xint3 from 
	     (select self(x), xint from x 
		where add_int(x, 4,2) = add_int(x, 10, -4))
             as t(x3, xint3)  where xint3 = add_int(x3, 2, 3)) order by 1;
select add_int(xint1, 
	       (select yint2 from 
                  (select yint from y where yint = 10) as t(yint2) 
                where yint2 = 10)) 
       on (select (select x from x where xint = 3) from x where xint = 4), 
       (select yint from y where (select yint from y where yint = 40)
				  = y_self(y).yint),
       add_int(yint1, (select xint1 from x where xint*10 = yint1))
       on (select y from y where yint = yint1)
from (select self(x), xint from x where add_int(x, xint, 1) > 
			(select 2 from y where yint = add_int(y, 40, 10)))
     as t(x1, xint1),
     (select y_self(y), yint from y where add_int(y, yint, yint) < 90)
     as t2(y1, yint1)
where add_int(xint1, (select xint2 from 
		         (select xint from x 
		          where add_int(self(x), xint, 0) = 3) as t(xint2)
		       where xint2 = 3))
   on (select y from y where (select yint+10 from y where yint = 30) = yint) > 
	(select xint3 from 
	     (select self(x), xint from x 
		where add_int(x, 4,2) = add_int(x, 10, -4))
             as t(x3, xint3)  where xint3 = add_int(x3, 2, 3))
 and add_int(y_self(y1), xint1, yint1) > 20 order by 1, 2, 3;
select add_int(yint, (select x1.xint from x where xint*10 = yint)) on y
 from x x1, y order by 1;
select add_int(yint, (select x1.xint from x where xint*10 = yint)) on y
 from y, x x1 order by 1;
select add_int(y1, 
	       (select x1.xint from x where xint*10 = y1.yint), 
	       (select yint2 from 
		  (select y1.yint from y where yint/10 =  x1.xint) as t(yint2))
	      )
 from x x1, y y1 order by 1;
select add_int(y1, 
	       (select x1.xint from x where xint*10 = y1.yint), 
	       (select yint2 from 
		  (select y1.yint from y where yint/10 =  x1.xint) as t(yint2))
	      )
 from y y1, x x1 order by 1 desc;
select add_int(y1, 
	       (select x1.xint+10 from x where xint*10 = y1.yint), 
	       (select yint2+5 from 
		  (select y1.yint+2 from y where yint/10 =  x1.xint) as t(yint2))
	      )
 from x x1, y y1 order by 1;
select xint1, yint1, add_int(y1, xint1+4, yint1/2) from 
   (select xint2+2 from 
	(select xint3+3 from 
	   (select xint+1 from x where xint > 1) as t(xint3)
	 where xint3 < 6) as t1(xint2)
    where xint2 > 6) as t2(xint1), 
   (select y2, yint2+20 from
	(select y3, yint3+30 from 
	   (select y, yint+10 from y where yint>10) as t(y3, yint3)
         where yint3 > xint1 * 5) as t1(y2, yint2)
    where yint2 > (xint1 * 10) - 20) as t3(y1, yint1) order by 1, 2;
select xint1, yint1, add_int(y1, xint1+4, yint1/2) from 
   (select xint2+2 from 
	(select xint3+3 from 
	   (select xint+1 from x where xint > 1) as t(xint3)
	 where xint3 < 6) as t1(xint2)
    where xint2 > 6) as t2(xint1), 
   (select y2, yint2+20 from
	(select y3, yint3+30 from 
	   (select y, yint+10 from y where yint>10) as t(y3, yint3)
         where yint3 > xint1 *5) as t1(y2, yint2)
   ) as t3(y1, yint1) order by 1, 2;
select xint1, yint1, add_int(y1, xint1+4, yint1/2) from 
   (select xint2+2 from 
	(select xint3+3 from 
	   (select xint+1 from x where xint > 1) as t(xint3)
	 where xint3 < 6) as t1(xint2)
    where xint2 > 6) as t2(xint1), 
   (select y2, yint2+20 from
	(select y3, yint3+30 from 
	   (select y, yint+10 from y where yint>10) as t(y3, yint3)
        ) as t1(y2, yint2)
    where yint2 > (xint1 * 10) - 20) as t3(y1, yint1) order by 1, 2;
select xint1, yint1, add_int(y1, xint1+4, yint1/2) from 
   (select xint2+2 from 
	(select xint3+3 from 
	   (select xint+1 from x where xint > 1) as t(xint3)
	 where xint3 < 6) as t1(xint2)
    where xint2 > 6) as t2(xint1), 
   (select y2, yint2+20 from
	(select y3, yint3+30 from 
	   (select y, yint+10 from y where yint>xint1) as t(y3, yint3)
        ) as t1(y2, yint2)
   ) as t3(y1, yint1) order by 1, 2;
select xint, yint1, add_int(y1, xint+4, yint1/2) from 
   x, 
   (select y2, yint2+20 from
	(select y3, yint3+30 from 
	   (select y, yint+10 from y where yint>xint+10) as t(y3, yint3)
        ) as t1(y2, yint2)
   ) as t3(y1, yint1)
where xint > 2 and yint1 > (select yint*4 from y where yint = 20) order by 1, 2;
select xint, yint, add_int(y, xint+4, yint/2) from 
   x, y
where xint > 2 and yint > (select yint from 
				(select yint from y where yint = 20) as t(yint)
                            where yint = 20) order by 1, 2;
select xint, yint1, add_int(y1, xint+4, yint1/2) from 
   x, 
   (select y2, yint2+20 from
	(select y3, yint3+30 from 
	   (select y, yint+10 from y where yint>xint+10) as t(y3, yint3)
        ) as t1(y2, yint2)
   ) as t3(y1, yint1)
where xint > 2 and yint1 > 
      (select yint*4 from y where yint = add_int(y1,10,10)) order by 1, 2;
select xint, yint, add_int(y, xint+4, yint/2) from 
   x, y
where xint > 2 and yint > (select yint from 
				(select yint from y 
                                 where yint = add_int(y,10,10)) as t(yint)
                            where yint = 20) order by 1, 2;
select xint, yint, add_int(y, xint+4, yint/2) from 
   y, x
where xint > 2 and yint > (select yint from 
				(select yint from y where yint = 20) as t(yint)
                            where yint = 20) order by 1, 2;
select xint, yint, add_int(y, xint+4, yint/2) from 
   y, x
where xint > 2 and yint > (select yint from 
				(select yint from y 
                                 where yint = add_int(y,10,10)) as t(yint)
                            where yint = 20) order by 1, 2;
select s, concat_str(s, s.xstr, '**') 
from all z, table(xs) as t(s) order by 2;
select s, s.xint, concat_str(s, s.xstr, '**') 
from all z, table(xs) as t(s) order by 2, 3;
select b1, b2 
from z,
     (select s, concat_str(s, s.xstr, '**') 
      from table((select xs from table({1}) as t1(c))
           ) as t(s)
     ) as t1(b1, b2) order by 2;
select z1.zint, b1, b2 
from z z1,
     (select s, concat_str(s, s.xstr, '**') from z z2, table(z2.xs) as t(s)
      where z1.zint > z2.zint
     ) as t1(b1, b2) order by 1, 3;
select xs into xs1 from z where zint = 321;
select s, concat_str(s, s.xstr, '**') from table(xs1) as t(s) order by 2;
select yint1, yint2, add_int(x1, xint1, 1) 
from y y0,
     (select x, xint, (select yint from y where yint = y0.yint),
                      (select yint-1 from y where yint = y0.yint)
      from x) as t(x1, xint1, yint1, yint2) order by 1, 2, 3;
select yint1, yint2, add_int(x1, xint1, 1) 
from y y0,
     (select x, xint, (select yint from y where yint = xint * 10),
                      (select yint-1 from y where yint = xint * 10)
      from x) as t(x1, xint1, yint1, yint2) order by 1, 2;
select s, concat_str(s, s.xstr, '**') from z, table(same_seq(z, xs)) as t(s) order by 2;
select z into :p1 from z where zint = 321;
select s, concat_str(s, s.xstr, '**') 
from z,	table(same_seq(:p1, xs)) as t(s) order by 2;
delete from x;
insert into x values (1, 'string 1');
insert into x values (2, 'string 2');
insert into x values (3, 'string 3');
insert into x values (4, 'string 4');
insert into x values (5, 'string 5');
delete from y;
insert into y(yint, ystr) values (10, 'string 10');
insert into y(yint, ystr) values (2, 'string 20');
insert into y(yint, ystr) values (3, 'string 3');
insert into y(yint, ystr) values (40, 'string 40');
insert into y(yint, ystr) values (5, 'string 5');
delete from x_1;
insert into x_1 values (10, 'string 10');
insert into x_1 values (2, 'string 20');
insert into x_1 values (3, 'string 3');
insert into x_1 values (40, 'string 40');
insert into x_1 values (5, 'string 5');
select add_int(x, xint, 4) from x where xint > 1 
union
select add_int(y, yint, 5) from y where yint < 40;
select add_int(x, xint, 4) from x where xint > 1 
union all
select add_int(y, yint, 5) from y where yint < 40 order by 1;
select add_int(x, xint, 4) from x where xint > 1 
difference
select add_int(y, yint, 5) from y where yint < 40;
select add_int(x, xint, 4) from x where xint > 1 
intersection
select add_int(y, yint, 5) from y where yint < 40;
select concat_str(u, ustr, '**ADDED TO UNION**') from (
	select x, xstr from x where xint > 1 
	union
	select x_1, xstr from x_1 where xint < 40) as t(u, ustr) order by 1;
select concat_str(u, ustr, '**ADDED TO DIFFERENCE**') from (
	select x, xstr from x where xint > 1 
	difference
	select x_1, xstr from x_1 where xint < 40) as t(u, ustr) order by 1;
select concat_str(u, ustr, '**ADDED TO INTERSECTION**') from (
	select x, xstr from x where xint > 1 
	intersection
	select x_1, xstr from x_1 where xint < 40) as t(u, ustr);
select add_int(u, uint, 20), concat_str(u, ustr, '*****') from (
	select x, add_int(x, xint, 4), xstr from x where xint > 1 
	union
	select x_1, add_int(x_1, xint, 5), xstr  from x_1 where xint < 40)
     as t(u, uint, ustr) order by 1, 2;
select add_int(u, uint, 20), concat_str(u, ustr, '*****') from (
	select x, add_int(x, xint, 4), xstr from x where xint > 1 
	difference
	select x_1, add_int(x_1, xint, 5), xstr  from x_1 where xint < 40)
     as t(u, uint, ustr) order by 1;
select add_int(u, uint, 20), concat_str(u, ustr, '*****') from (
	select x, add_int(x, xint, 4), xstr from x where xint > 1 
	intersection
	select x_1, add_int(x_1, xint, 5), xstr  from x_1 where xint < 40)
     as t(u, uint, ustr);
select add_int(u, uint, 20), concat_str(u, ustr, '*****') from (
	(select x, add_int(x, xint, 4), xstr from x where xint > 1 
 	 union
	 select x_1, add_int(x_1, xint, 5), xstr  from x_1 where xint < 40)
       union
	(select x, add_int(x, xint, 4), xstr from x where xint > 1 
 	 difference
	 select x_1, add_int(x_1, xint, 5), xstr  from x_1 where xint < 40))
     as t(u, uint, ustr) order by 1, 2;
select add_int(u, uint, 20), concat_str(u, ustr, '*****') from (
	(select x, add_int(x, xint, 4), xstr from x where xint > 1 
 	 union
	 select x_1, add_int(x_1, xint, 5), xstr  from x_1 where xint < 40)
       difference
	(select x, add_int(x, xint, 4), xstr from x where xint > 1 
 	 difference
	 select x_1, add_int(x_1, xint, 5), xstr  from x_1 where xint < 40))
     as t(u, uint, ustr) order by 1;
select add_int(u, uint, 20), concat_str(u, ustr, '*****') from (
	(select x, add_int(x, xint, 4), xstr from x where xint > 1 
 	 union
	 select x_1, add_int(x_1, xint, 5), xstr  from x_1 where xint < 40)
       intersection
	(select x, add_int(x, xint, 4), xstr from x where xint > 1 
 	 union
	 select x_1, add_int(x_1, xint, 5), xstr  from x_1 where xint < 40))
     as t(u, uint, ustr) order by 1, 2;
select * from x
where 4 in ((select add_int(x, 1, 2) from y) 
		union 
	    (select add_int(x, xint,1) from y));
select * from x
where 4 in ((select add_int(x, yint, xint) from y) 
		union 
	    (select add_int(x, xint,1) from y)) order by 1;
delete from x;
insert into x values (1, 'string 1');
insert into x values (2, 'string 2');
insert into x values (3, 'string 3');
insert into x values (4, 'string 4');
insert into x values (5, 'string 5');
delete from y;
insert into y(yint, ystr) values (10, 'string 10');
insert into y(yint, ystr) values (20, 'string 20');
insert into y(yint, ystr) values (30, 'string 30');
insert into y(yint, ystr) values (40, 'string 40');
insert into y(yint, ystr) values (50, 'string 50');
update x set xint = add_int(x, xint, 7);
select * from x order by 1;
update x set 
  xint = (select add_int(y, xint, yint) from y where (yint/10)+7 = xint),
  xstr = (select concat_str(y, xstr, ystr) from y where (yint/10)+7 = xint);
select * from x order by 1;
update y set 
  yint = (select sum(f) from (select add_int(x, xint, -10) from x 
	                      where xint > 20) as t(f))
where ystr > concat_str(y, 'string', ' 40');
select * from y order by 1;
insert into x values (
  (select add_int(y, yint, 10) from y where yint = 40),
  (select concat_str(x, xstr, '**new xstr**') from x 
	where xint = add_int(x, 8, 10)));
select * from x order by 1;
insert into x values (
  (select sum(f) from (select add_int(x, xint, -10) from x 
	               where xint > 20) as t(f)),
  (select concat_str(x, concat_str(x, 'On the Front--', xstr), '--On the Back')
   from x where xint = add_int(x, 20, 9)));
select * from x order by 1;
delete from x where add_int(x, xint, 5) = 
  (select add_int(y, yint, 15) from y where yint = add_int(x, xint, -10));
select * from x order by 1;
delete from x 
where add_int(xint, -40) on x = (select yint from y where yint > 50) or
      xstr > concat_str('string 4', 'string 40') on 
	     (select y from y where yint = add_int(y, 10, 10));
select * from x order by 1;
insert into x values(
	add_int(1, 2) on (select x from x where xint = 51),
	concat_str('*1*', '--2--') on (select y from y where yint = 142));
select * from x order by 1;
insert into x (xint) values(
	add_int(1,2) on (select x from x where xint=10001));
select * from x order by 1;
insert into x (xint) values(
	add_int(1, 2) on (select x from x where xint=NULL));
select * from x order by 1;
delete from x;
insert into x values (1, 'string 1');
insert into x values (2, 'string 2');
insert into x values (3, 'string 3');
insert into x values (4, 'string 4');
insert into x values (5, 'string 5');
delete from y;
insert into y(yint, ystr) values (10, 'string 10');
insert into y(yint, ystr) values (2, 'string 20');
insert into y(yint, ystr) values (3, 'string 3');
insert into y(yint, ystr) values (40, 'string 40');
insert into y(yint, ystr) values (5, 'string 5');
select ambiguous(v_x, v_xint, 4) from v_x order by 1; 
select view_method(v_x, v_xint) from v_x order by 1;
select add_int(computed_x, vcomp_int, 4), add_int(computed_x, vcomp_int-3, 10) 
      from computed_x order by 1;
select * from meth_x order by 1;
select meth_int, concat_str(meth_x, meth_str, '**added to view**') from meth_x order by 1;
select meth_int, ambiguous(meth_x, meth_int, meth_int * 4) from meth_x order by 1;
delete from x;
insert into x values (1, 'string 1') to p1;
insert into x values (2, 'string 2') to p2;
insert into x values (3, 'string 3') to p3;
insert into x values (4, 'string 4') to p4;
insert into x values (5, 'string 5') to p5;
delete from y;
insert into y values (10, 'string 10', p1);
insert into y values (2, 'string 20', p2);
insert into y values (3, 'string 3', p3);
insert into y values (40, 'string 40', p4);
insert into y values (5, 'string 5', p5);
select add_int(x, xint, 4), concat_str(y, ystr, '**ADD TO YSTR**') from
   x, y where xint = 5 and yint = 40;
select add_int(x, xint, 4), concat_str(y, ystr, '**ADD TO YSTR**') from
   x, y where xint = 5 and (xint <> 3 or xint <> 2) order by 1, 2;
select add_int(x, xint, 4), concat_str(y, ystr, '**ADD TO YSTR**') from
   x, y where (xint <> 3 or xint <> 2) and (yint = 40 or yint = 2) order by 1, 2;
select add_int(x, xint, 4), concat_str(y, ystr, '**ADD TO YSTR**') from
   x, y where (xint <> 3 and xint <> 2) and (yint = 40 or yint = 2) order by 1, 2;
select add_int(x, xint, 4), concat_str(y, ystr, '**ADD TO YSTR**') from
   x, y where (xint <> 3 and yint <> 2) and (yint = 40 or yint = 2) order by 1, 2;
select add_int(x, xint, 4), concat_str(y, ystr, '**ADD TO YSTR**') from
   x, y where (xint <> 3 and yint <> 2) and (yint = 40 or xint = 2) order by 1, 2;
select add_int(x, xint, 4), concat_str(y, ystr, '**ADD TO YSTR**') from x, y 
  where (xint <> 3 and (xint <> 3 or yint <> 2) and yint <> 2) and 
        (yint = 40 or xint = 2) order by 1, 2;
select add_int(x, xint, 4), concat_str(y, ystr, '**ADD TO YSTR**') from x, y 
  where (xint <> 3 and (xint <> 3 or yint <> 2) and yint <> 2) or 
        (yint = 40 or xint = 2) order by 1, 2;
select add_int(x, xint, 4), concat_str(y, ystr, '**ADD TO YSTR**') from
   x, y where (xint <> 3 and xint <> 2) and (yint = 40 or yint = 2) order by 1, 2;
select add_int(x, xint, 4), concat_str(ty, tystr, '**ADD TO YSTR**') from
   x, (select y, yint, ystr from y) as t(ty, tyint, tystr)
   where (xint <> 3 and xint <> 2) and (tyint = 40 or tyint = 2) order by 1, 2;
select xint, yint from x, y where xint > 1 and add_int(y, yint, 5) = 15 order by 1, 2;
select xint, yint from x, y where yint > 3 and add_int(y, yint, 5) = 15 order by 1, 2;
select xint, yint from x, y 
  where (yint > 3 and xint = 5) and add_int(y, yint, 5) = 15 and 
        concat_str(x, xstr, '**') = 'string 5**' order by 1, 2;
select xint, yint from x, y 
  where (yint > 3 or add_int(y, yint, 5) = 15) and 
        (xint = 5 or concat_str(x, xstr, '**') = 'string 5**') order by 1, 2;
select add_int(y, yint, 6) from y where to_x.xint > 3;
select add_int(y, yint, 6), to_x.xint from y where yint > 3 order by 1, 2;
delete from x;
insert into x values (1, 'x string 1') to p1;
insert into x values (2, 'x string 2') to p2;
insert into x values (3, 'x string 3') to p3;
insert into x values (4, 'x string 4') to p4;
delete from y;
insert into y values (10, 'y string 10', p1);
insert into y values (20, 'y string 20', p2);
insert into y values (30, 'y string 30', p3);
insert into y values (40, 'y string 40', p4);
select xint, yint from x, y 
  where xint = yint / 10 and add_int(x, xint, 5) + 20 >= add_int(y, yint, 2) order by 1, 2;
select concat_str(x, xstr, ' *we added 10*') from x
  where add_int(x, xint, 10) < 14 and add_int(x, xint, 10) > 11 order by 1;
select count(*) from x, y where add_int(x, xint, 5) > 6;
select avg(add_int(x, xint, 10)) from x;
insert into x values (11, 'x string 1');
insert into x values (12, 'x string 2');
insert into x values (13, 'x string 3');
insert into x values (14, 'x string 4');
insert into x values (24, 'x string 4');
select xstr, avg(add_int(x, xint, 10)) from x group by xstr;
select xstr, avg(add_int(x, xint, 10)) from x group by xstr
	having xstr <> 'x string 2';
delete from x where xint > 10;
select add_int(x, add_int(x, xint, 20), xint) from x order by 1;
select xint, add_int(x, 10 + add_int(x, xint, 20), xint), 
  concat_str(x, xstr, '****') from x 
  where x.xint < 4 and concat_str(x, xstr, '****') > 'x string 1****' order by 1;
select add_int(y, add_int(x, xint, 10), 15) from x, y where xint = yint / 10 order by 1;
select self(x).xint, y_self(y).yint from x, y where xint = yint / 10 order by 1;
select add_int(x, xint, y_self(y).yint) from x, y order by 1;
select add_int(y, add_int(x, xint, yint)+add_int(y, xint, 40), -5) from x, y order by 1;
select add_int(x, xint, yint) from x, y order by 1;
select add_int(x, 1, 2) from x;
select add_int(x, 1, 2), add_int(x, 3, 4) from x;
select self(x) into p1 from x where xint = 3;
select * from x where x = p1;
select to_x.xint, add_int(y, yint, yint) from y order by 1;
select to_x.xint, add_int(y, yint, y_self(y).yint) from y order by 1;
select add_int(to_x, to_x.xint, yint) from y order by 1;
select add_int(to_x, to_x.xint+3, yint) from y order by 1;
select to_x.xint, add_int(to_x, to_x.xint, yint) from y order by 1;
select to_x.xint, add_int(to_x, add_int(y, to_x.xint, 4), yint) from y order by 1;
select add_int(to_x, self(to_x).xint, y_self(y).yint) from y order by 1;
select add_int(p, p.xint, self(p).xint) from (select to_x from y) as tmp(p) order by 1;
select y_self(y).to_x.xint, add_int(y, 4, add_int(y, yint, 1)) from y order by 1;
select add_int(xint, 5) on x from x order by 1;
select add_int(xint, 7) on x * 4 from x 
	where concat_str(xstr, '**') on x <> 'x string 2**' order by 1;
select add_int(1, xint) on self() on x from x order by 1;
select x into p1 from x where xint = 3;
select yint, add_int(y, yint, self(p1).xint) from y order by 1;
select esqlx_add_int(x2, 5) from x2 order by 1;
select add_int(xint, 1) on (select x from x where xint = 3) from x order by 1;
select y_num_in_class(class y), add_int(y, yint, 5) from y order by 1, 2;
select add_int(y, yint, y_num_in_class(class y)) from y order by 1;
select y_num_in_class() on class y from x;
select ambiguous(x, xint, 4) from x order by 1;
alter class x rename function of ambiguous as mul_int;
select ambiguous(x, xint, 4) from x order by 1;
alter class x rename function of ambiguous as add_int;
select ambiguous(x, xint, 4) from x order by 1;
select concat_str(union_xy, vunion_str, '**ADDED TO UNION**') from union_xy;
select concat_str(diff_xy, vdiff_str, '**ADDED TO DIFFERENCE**') from diff_xy;
select concat_str(inter_xy, vinter_str, '**ADDED TO INTERSECT**')
        from inter_xy;
rollback;

--+ holdcas off;
