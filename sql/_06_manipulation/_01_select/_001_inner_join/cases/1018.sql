--test multiple rows select using union, difference keyword

create class ts01(
    col1 char(8) not null,
    col2 varchar(40),
    col3   char(9),
    col4 varchar(60),
    col5 numeric(12,1));

create class ts02(
    col1 char(8) not null,
    col2 varchar(40),
    col3   char(9),
    col4 varchar(60));

insert into ts01(col1, col2, col3, col4, col5) values('****1','hihi','*********','', 4.0);
insert into ts01(col1, col2, col3, col4, col5) values('01363','haha','*********','', 4.0);
insert into ts02(col1, col2, col3, col4) values('00393','yaya','*********','');
insert into ts02(col1, col2, col3, col4) values('****1','hihi','*********','');
insert into ts02(col1, col2, col3, col4) values('****2','huhu','*********','');
insert into ts02(col1, col2, col3, col4) values('****3','hoho','*********','');
insert into ts02(col1, col2, col3, col4) values('01363','haha','*********','');

select col1, col2, col3, col4, col5, 1 from   ts01 order by 1;
select col1, col2, col3, col4, 0, 0  from   ts02 order by 1;
select col1, col2, col3, col4, 0, 0  from   ts01 order by 1;
select col1, col2, col3, col4, col5, 1  from   ts01
  union all
  select col1, col2, col3, col4, 0, 0 from   ts02
  difference
  select col1, col2, col3, col4, 0, 0  from   ts01 order by 1;
select col1, col2, col3, col4, col5, 1  from   ts01
  union all
  ( select col1, col2, col3, col4, 0, 0   from   ts02
    difference
    select col1, col2, col3, col4, 0, 0    from   ts01 ) order by 1;
select col1, col2, col3, col4, col5, 1  from   ts01
  union all
  ( select col1, col2, col3, col4, 0.0, 0    from   ts02
    difference
    select col1, col2, col3, col4, 0.0, 0    from   ts01 ) order by 1;


drop class ts01;
drop class ts02;
