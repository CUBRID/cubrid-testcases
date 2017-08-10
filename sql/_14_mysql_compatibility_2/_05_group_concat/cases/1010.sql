-- misc tests : tests with expressions , errors

create table tab1 (name char varying, i1 integer ,b blob default null);
insert into tab1 values('gigi',3, NULL);
insert into tab1 values('gigi',5, NULL);
insert into tab1 values('gogu',4, NULL);
insert into tab1 values('gogu',3, NULL);
insert into tab1 values('maria',5, NULL);
insert into tab1 values('maria',2, NULL);
insert into tab1 values('ion',6, NULL);
insert into tab1 values('ion',5, NULL);
insert into tab1 values('ion',5, NULL);


select i1,group_concat(name+'-' order by name+'-' separator '_') from tab1 group by i1;

select name,group_concat(repeat(name,1) order by repeat (name,1) separator ' _ ') from tab1 group by name;

select name,group_concat(distinct repeat(name,1) order by repeat (name,1) separator ' _ ') from tab1 group by name;

select name,group_concat(i1+2 order by i1+2 separator ' + ') from tab1 group by name;

select name,group_concat(i1+2 order by 1 separator ' + ') from tab1 group by name;


-- errors

select i1,group_concat(name order by i1 ) from tab1 group by i1;

select i1,group_concat(name order by 2 ) from tab1 group by i1;

select i1,group_concat(name order by 0 ) from tab1 group by i1;

select i1,group_concat(name order by 'a' ) from tab1 group by i1;

select i1,group_concat(b order by b ) from tab1 group by i1;


select i1,group_concat(orderby_num() order by 1 ) from tab1 group by i1;

select i1,group_concat(orderby_num() order by orderby_num() ) from tab1 group by i1;

select i1,group_concat(name order by orderby_num() ) from tab1 group by i1;

-- TODO


drop table tab1;

