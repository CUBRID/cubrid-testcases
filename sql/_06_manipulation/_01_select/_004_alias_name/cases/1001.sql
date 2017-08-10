--test alias keyword for result of aggregate function

create class hi ( a int , b string );
insert into hi values ( 1, 'hihi');
insert into hi values ( 2, 'haha');
insert into hi values ( 3, 'haha');
insert into hi values ( 4, 'haha');
insert into hi values ( 5, 'haha');
insert into hi values ( 6, 'haha');
select sum(a)+avg(a)+stddev(a)+variance(a)  as  "aaa"  from hi order by 1;
select sum(a)  as  "hi hi"  from hi order by 1;
select sum(a)  d  from hi order by 1;
select sum(a)  "hi hi"  from hi order by 1;


drop class hi;
