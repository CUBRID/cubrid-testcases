create view w as select 1 as a, 2 as b;
alter view w as select 23 as d union select sqrt(100);
desc w;
drop view w;
