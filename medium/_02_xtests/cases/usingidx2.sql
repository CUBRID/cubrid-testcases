autocommit off;
create class small(i int, s char(20), l varchar(255)) ;
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
create unique index u_small on small(i, s, l);
create unique index u_medium on medium(i, s, l);
create unique index u_large on large(i, s, l);
create index i_small on small(s, i);
create index i_medium on medium(s, i);
create index i_large on large(s, i);

select count(*)
  from large
 where large.i < 5 and s >= 't';
select count(*)
  from large
 where large.i < 5 and s >= 't'
 using index i_large;
select /*+ USE_IDX ORDERED */ count(*)
  from medium, large
 where medium.i = large.i and medium.s = large.s and medium.l = large.l;
select /*+ USE_IDX ORDERED */ count(*)
  from medium, large
 where medium.i = large.i and medium.s = large.s and medium.l = large.l
 using index i_medium, i_large;
select /*+ USE_IDX ORDERED */ count(*)
  from small, medium, large
 where small.i = medium.i and small.s = large.s;
select /*+ USE_IDX ORDERED */ count(*)
  from small, medium, large
 where small.i = medium.i and small.s = large.s
 using index i_large, u_large;
select /*+ USE_IDX ORDERED */ count(*)
  from medium, large
 where large.i <= 1000 and medium.s = large.s and medium.i = large.i;
select /*+ USE_IDX ORDERED */ count(*)
  from medium, large
 where large.i <= 1000 and medium.s = large.s and medium.i = large.i
 using index i_large;
select count(*)
  from large, small
 where large.i = small.i
 using index u_small;
select count(*)
  from large, small
 where large.i = small.i
 using index u_large;
rollback;
