autocommit off;
create class v (a int, b int, c int, d varchar(5), e varchar(5), f varchar(5));
create class w (a int, b int, c int, d varchar(5), e varchar(5), f varchar(5));
create class x (a int, b int, c int, d varchar(5), e varchar(5), f varchar(5));
create class y (a int, b int, c int, d varchar(5), e varchar(5), f varchar(5));
create class z (a int, b int, c int, d varchar(5), e varchar(5), f varchar(5));
insert into v values (1, 1, 1, 'v', 'v', 'v');
insert into w values (2, 2, 2, 'w', 'w', 'w');
insert into x values (3, 3, 3, 'x', 'x', 'x');
insert into y values (4, 4, 4, 'y', 'y', 'y');
insert into z values (5, 5, 5, 'z', 'z', 'z');
select * 
from (select NULL, b,    c,    NA,   e,    f    from v union
      select a,    NULL, c,    d,    NA,   f    from w union
      select a,    b,    NULL, d,    e,    NA   from x union
      select NULL, NULL, NULL, NA,   NA,   NA   from y union
      select a,    b,    c,    d,    e,    f    from z) 
      as t(aa, bb, cc, dd, ee, ff);
select * 
from (select NULL, NULL, NULL from v union
      select a,    NULL, NULL from w union
      select NULL, b,    NULL from x union
      select NULL, NULL, c    from y union
      select 5,    5,    5    from z) 
      as t(aa, bb, cc);
select * 
from (select NA,   NA,   NA   from v union
      select a,    NA,   NA   from w union 
      select NA,   b,    NA   from x union
      select NA,   NA,   c    from y union
      select 5,    5,    5    from z)
      as t(aa, bb, cc); 
select aa as pp, bb as qq, cc as rr
from (select NULL as p, NULL as q, NULL as r from v union
      select a,    NULL, NULL from w union 
      select NULL, b,    NULL from x union
      select NULL, NULL, c    from y union
      select 5,    5,    5    from z)
      as t(aa, bb, cc);
select aa as pp, bb as qq, cc as rr
from (select 1 as p, 1 as q, 1 as r from v union
      select a,    NULL, NULL from w union
      select NULL, b,    NULL from x union
      select NULL, NULL, c    from y union
      select 5,    5,    5    from z)
      as t(aa, bb, cc);
select aa, bb, cc 
from (select 1,    1,    1    from v union
      select a,    NULL, NULL from w union
      select NULL, b,    NULL from x union
      select NULL, NULL, c    from y union
      select 5,    5,    5    from z)
      as t(aa, bb, cc);
select t.aa, t.bb, t.cc
from (select 1,    1,    1    from v union
      select a,    NULL, NULL from w union
      select NULL, NA,   NULL from x union
      select NULL, NULL, NA   from y union
      select 5,    5,    5    from z)
      as t (aa, bb, cc);
select * 
from (select NULL, NULL, NULL from v union
      select d,    NULL, NULL from w union
      select NULL, e,    NULL from x union
      select NULL, NULL, f    from y union
      select 'z',  'z',  'z'  from z)
      as t(dd, ee, ff);
select *
from (select NULL, NULL, NULL from v union
      select d,    NULL, NULL from w union
      select NULL, e,    NULL from x union
      select NULL, NULL, f    from y union
      select cast('z' as varchar(5)), cast('z' as varchar(5)),  
             cast('z' as varchar(5)) from z)
      as t(dd, ee, ff);
select *
from (select NULL, NULL, NULL from v union
      select d,    NULL, NULL from w union
      select NULL, e,    NULL from x union
      select NULL, NULL, f    from y union
      select cast('z' as varchar(3)), cast('z' as varchar(4)),  
             cast('z' as varchar(5)) from z)
      as t(dd, ee, ff);
select * 
from (select NULL, NULL, NULL from v union
      select d,    NULL, NULL from w union
      select NULL, e,    NULL from x union
      select NULL, NULL, f    from y union
      select cast('z' as varchar(5)), cast('z' as varchar(6)),  
             cast('z' as varchar(7)) from z)
      as t(dd, ee, ff);
select *
from (select NA,   NA,   NA   from v union
      select d,    NA,   NA   from w union
      select NA,   e,    NA   from x union
      select NA,   NA,   f    from y)
      as t(dd, ee, ff);
select dd as pp, ee as qq, ff as rr 
from (select NULL as p, NULL as q, NULL as r from v union
      select d,    NULL, NULL from w union
      select NULL, e,    NULL from x union
      select NULL, NULL, f    from y)
      as t(dd, ee, ff);
select dd as pp, ee as qq, ff as rr
from (select cast('v' as varchar(5)) as p, cast('v' as varchar(5)) as q, 
             cast('v' as varchar(5)) as r from v union
      select d,    NULL, NULL from w union
      select NULL, e,    NULL from x union
      select NULL, NULL, f    from y)
      as t(dd, ee, ff);
select cast(dd as varchar(5)), cast(ee as varchar(5)), 
       cast(ff as varchar(5))
from (select cast('v' as varchar(5)), cast('v' as varchar(5)),    
             cast('v' as varchar(5)) from v union
      select d,    NULL, NULL from w union
      select NULL, e,    NULL from x union
      select NULL, NULL, f    from y)
      as t(dd, ee, ff);
select cast(dd as varchar(5)), cast(ee as varchar(5)), 
       cast(ff as varchar(5))
from (select cast('v' as varchar(5)), cast('v' as varchar(5)), 
             cast('v' as varchar(5)) from v union
      select d,    NULL, NULL from w union
      select NULL, NA,   NULL from x union
      select NULL, NULL, NA   from y)
      as t(dd, ee, ff);
rollback work;
rollback;
