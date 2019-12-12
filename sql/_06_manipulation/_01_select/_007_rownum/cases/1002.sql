--test rownum, inst_num with many plan

create class small(i int, s char(20), l varchar(255));
 create class medium(i int, s char(20), l varchar(255));
 create class large(i int, s char(20), l varchar(255));
 insert into small values (NULL, 'null', '');
 insert into small values (0, 'zero', 'varchar(255)');
 insert into small values (1, 'one', 'varchar(255)');
 insert into small values (2,'two', 'varchar(255)');
 insert into small values (3,'three', 'varchar(255)');
 insert into small values (4,'four', 'varchar(255)');
 insert into small values (5,'five', 'varchar(255)');
 insert into small values (6,'six', 'varchar(255)');
 insert into small values (7,'seven', 'varchar(255)');
 insert into small values (8,'eight', 'varchar(255)');
 insert into small values (9,'nine', 'varchar(255)');
 insert into medium select i, s, l from small;
 insert into medium select i+10, 'one '+s, l from small;
 insert into medium select i+20, 'two '+s, l from small;
 insert into medium select i+30, 'three '+s, l from small;
 insert into medium select i+40, 'four '+s, l from small;
 insert into medium select i+50, 'five '+s, l from small;
 insert into medium select i+60, 'six '+s, l from small;
 insert into medium select i+70, 'seven '+s, l from small;
 insert into medium select i+80, 'eight '+s, l from small;
 insert into medium select i+90, 'nine '+s, l from small;
 insert into large select i, s, l from medium;
 insert into large select i+100, 'one zero '+s, l from medium where i<10;
 insert into large select i+100, 'one '+s, l from medium where i>=10;
 insert into large select i+200, 'two zero '+s, l from medium where i<10;
 insert into large select i+200, 'two '+s, l from medium where i>=10;
 insert into large select i+300, 'three zero '+s, l from medium where i<10;
 insert into large select i+300, 'three '+s, l from medium where i>=10;
 insert into large select i+400, 'four zero '+s, l from medium where i<10;
 insert into large select i+400, 'four '+s, l from medium where i>=10;
 insert into large select i+500, 'five zero '+s, l from medium where i<10;
 insert into large select i+500, 'five '+s, l from medium where i>=10;
 insert into large select i+600, 'six zero '+s, l from medium where i<10;
 insert into large select i+600, 'six '+s, l from medium where i>=10;
 insert into large select i+700, 'seven zero '+s, l from medium where i<10;
 insert into large select i+700, 'seven '+s, l from medium where i>=10;
 insert into large select i+800, 'eight zero '+s, l from medium where i<10;
 insert into large select i+800, 'eight '+s, l from medium where i>=10;
 insert into large select i+900, 'nine zero '+s, l from medium where i<10;
 insert into large select i+900, 'nine '+s, l from medium where i>=10;
----------------
--case 1
----------------

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ orderby_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
order by small.i
for orderby_num() > 9;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ orderby_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
order by small.i
for orderby_num() = 9;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ orderby_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
order by small.i
for (  orderby_num() = 9 or orderby_num() = 10);

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ orderby_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
order by small.i
for orderby_num() in ( 9,10);

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ orderby_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
order by small.i
for (orderby_num() > 8 and orderby_num()> 9);

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ orderby_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
order by small.i
for ( orderby_num() > 8 or orderby_num()> 9 );

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ orderby_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
order by small.i
for orderby_num() = 10;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ orderby_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
order by small.i
for orderby_num() <=0;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ orderby_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
order by small.i
for orderby_num() > 10;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ orderby_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
order by small.i for orderby_num() >= 10
  and orderby_num() >= 11;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, inst_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
order by small.i for orderby_num() >= 10;

-----------------
--case 2
-----------------
select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum > 9;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum = 9;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and (  rownum = 9 or rownum = 10);

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum in ( 9,10);

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum > 8 and rownum> 9;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and ( rownum > 8 or rownum> 9 );

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum = 10;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum <=0;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum > 10;

--------------
-- case 3
--------------
select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum > 9;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum = 9;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and (  rownum = 9 or rownum = 10);

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum in ( 9,10);

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum > 8 and rownum> 9;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and ( rownum > 8 or rownum> 9 );

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum = 10;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum <=0;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ rownum, small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and rownum > 10;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ inst_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and inst_num() > 9;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ inst_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and inst_num() = 10
and inst_num() in ( 9,10);

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ inst_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and (  inst_num() = 9 or inst_num() = 10);

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ inst_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and inst_num() in ( 9,10);

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ inst_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and inst_num() > 8 and inst_num()> 9;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ inst_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and ( inst_num() > 8 or inst_num()> 9 );

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ inst_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and inst_num() = 10;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ inst_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and inst_num() <=0;

select /*+ ORDERED USE_MERGE(medium) USE_NL(large) */ inst_num(), small.i, medium.i, large.i
from small, medium, large
where small.i=medium.i and medium.i=large.i and small.i<10
and inst_num() > 10;


drop small;
drop medium;
drop large;
