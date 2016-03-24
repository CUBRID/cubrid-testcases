create class xoo ( a int not null, b varchar(3) not null, c int not null, d int not null, order_no int);
insert into xoo values(5, '3', 1, 2, 1);
insert into xoo values(4, '7', 2, 1, 2);
insert into xoo values(6, '8', 5, 9, 3);
insert into xoo values(1, '2', 7, 8, 4);
insert into xoo values(7, '6', 6, 3, 5);

create index idx on xoo (a,b,c);

select (select a from xoo order by b for orderby_num() = 1) as c1,
        a
from xoo order by 1,2;

select (select a from xoo order by b for orderby_num() = 1) as c1,
       (select a from xoo order by b for orderby_num() = 1) as c2,
        a
from xoo order by 1,2,3;

select (select (select a+10 from xoo where rownum = 1 using index none)
        from xoo order by b for orderby_num() = 1) as c1,
        a
from xoo order by 1,2;

select (select (select a+10 from xoo where rownum = 1 using index none)
        from xoo order by b for orderby_num() = 1) as c1,
       (select (select a+10 from xoo where rownum = 1 using index none)
        from xoo order by b for orderby_num() = 1) as c2,
        a
from xoo order by 1,2,3;

select (select (select a+10 from xoo order by 1 for orderby_num() = 1)
        from xoo order by b for orderby_num() = 1) as c1,
        a
from xoo order by 1,2;

select (select (select a+10 from xoo order by 1 for orderby_num() = 1)
        from xoo order by b for orderby_num() = 1) as c1,
       (select (select a+10 from xoo order by 1 for orderby_num() = 1)
        from xoo order by b for orderby_num() = 1) as c2,
        a
from xoo order by 1,2,3;

select (select (select a+10 from xoo order by b for orderby_num() = 1)
        from xoo order by b for orderby_num() = 1) as c1,
        a
from xoo order by 1,2;

select (select (select a+10 from xoo order by b for orderby_num() = 1)
        from xoo order by b for orderby_num() = 1) as c1,
       (select (select a+10 from xoo order by b for orderby_num() = 1)
        from xoo order by b for orderby_num() = 1) as c2,
        a
from xoo order by 1,2,3;

select (select (select a+10
                from xoo
                order by b for orderby_num() = 1)
        from xoo
        order by b for orderby_num() = 1) as c1,
       (select (select a+10
                from xoo
                order by b for orderby_num() = 1)
        from xoo
        order by b for orderby_num() = 1) as c2,
        a
from xoo order by 1,2,3;


drop table xoo;
