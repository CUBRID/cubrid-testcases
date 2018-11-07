--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';


CREATE TABLE participant2 (host_year INT, nation CHAR(3), gold INT, silver INT, bronze INT)
PARTITION BY RANGE (host_year)
(PARTITION before_2000 VALUES LESS THAN (2000),
PARTITION before_2008 VALUES LESS THAN (2008) );
 
INSERT INTO participant2 VALUES (1988, 'NZL', 3, 2, 8);
INSERT INTO participant2 VALUES (1988, 'CAN', 3, 2, 5);
INSERT INTO participant2 VALUES (1996, 'KOR', 7, 15, 5);
INSERT INTO participant2 VALUES (2000, 'RUS', 32, 28, 28);
INSERT INTO participant2 VALUES (2004, 'JPN', 16, 9, 12);

create index i_p2_hy on participant2(host_year) with online;
--TEST
select /*+ recompile */ host_year from participant2 where host_year < 2000 and rownum<100 order by host_year desc;
--TEST
select /*+ recompile use_desc_idx */ host_year from participant2 where host_year < 2000 and rownum<100 using index i_p2_hy;

--TEST
select /*+ recompile */ host_year from participant2 where host_year between 1 and 3000 and rownum<100 order by host_year desc;
--TEST
select /*+ recompile use_desc_idx */ host_year from participant2 where host_year between 1 and 3000 and rownum<100 using index i_p2_hy;

create index i_p2_nation on participant2(nation);
--TEST
select /*+ recompile */ nation from participant2 where nation  >= 'A' and rownum<100 order by nation desc;
--TEST
select /*+ recompile use_desc_idx */ nation from participant2 where nation>='A' and rownum<100 using index i_p2_nation;
--TEST
select /*+ recompile */ nation from participant2 where nation  >= 'A' and rownum<100 order by nation desc;
--TEST
select /*+ recompile use_desc_idx */ nation from participant2 where nation>='A' and rownum<100 using index i_p2_nation;


drop table participant2;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
