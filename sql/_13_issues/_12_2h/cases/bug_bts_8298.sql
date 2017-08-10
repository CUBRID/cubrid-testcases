CREATE TABLE participant2 ( host_year INT, nation CHAR(3), gold INT, silver INT, bronze INT)
PARTITION BY RANGE (host_year)
( PARTITION before_2000 VALUES LESS THAN (2000),
PARTITION before_2008 VALUES LESS THAN (2008) );


-- check for crash

CREATE TABLE participant2 ( host_year INT, nation CHAR(3), gold INT, silver INT, bronze INT)
PARTITION BY RANGE (host_year)
( PARTITION before_2000 VALUES LESS THAN (2000),
PARTITION before_2008 VALUES LESS THAN (2008) );

create index ind on participant2(log10(gold));

create index ind2 on participant2(host_year) where host_year > 1990;

show tables;

select * from participant2 where log10(gold)>0;

select /*+ recompile */ * from participant2__p__before_2008 where log10(gold)>0;

select /*+ recompile */ * from participant2__p__before_2008 where host_year > 1990 using index ind2(+);

select /*+ recompile */ * from participant2__p__before_2000 where log10(gold)>0;

drop table participant2;
CREATE TABLE participant2 ( host_year INT, gold INT)
PARTITION BY RANGE (host_year)
( PARTITION before_2000 VALUES LESS THAN (2000),
PARTITION before_2008 VALUES LESS THAN (2008) );

create index ind on participant2(log10(gold));

create index ind2 on participant2(host_year) where host_year > 2004;

insert into participant2 values (1996, 2);

insert into participant2 values (1998, 3);

insert into participant2 values (2004, 2);

insert into participant2 values (2006, 2);

select /*+ recompile */ * from participant2__p__before_2008 where log10(gold)>0;

select /*+ recompile */ * from participant2__p__before_2008 where host_year > 2004 using index ind2(+);

drop table participant2;
CREATE TABLE participant2 ( host_year INT, gold INT)
PARTITION BY RANGE (host_year)
( PARTITION before_2000 VALUES LESS THAN (2000),
PARTITION before_2008 VALUES LESS THAN (2008) );

insert into participant2 values (1996, 2);

insert into participant2 values (1998, 3);

insert into participant2 values (2004, 2);

insert into participant2 values (2006, 2);

create index ind on participant2(log10(gold));

create index ind2 on participant2(host_year) where host_year > 2004;

select /*+ recompile */ * from participant2__p__before_2008 where log10(gold)>0;

select /*+ recompile */ * from participant2__p__before_2008 where host_year > 2004 using index ind2(+);

select /*+ recompile */ * from participant2__p__before_2000 where log10(gold)>0;

drop table participant2;


CREATE TABLE participant2 ( host_year INT, gold INT);

insert into participant2 values (1996, 2);

insert into participant2 values (1998, 3);

insert into participant2 values (2004, 2);

insert into participant2 values (2006, 2);

create index ind on participant2(log10(gold));

create index ind2 on participant2(host_year) where host_year > 2004;

ALTER TABLE participant2 PARTITION BY RANGE (host_year)
					( PARTITION before_2000 VALUES LESS THAN (2000),
					PARTITION before_2008 VALUES LESS THAN (2008) );
					
select /*+ recompile */ * from participant2__p__before_2008 where log10(gold)>0;

select /*+ recompile */ * from participant2__p__before_2008 where host_year > 2004 using index ind2(+);

select /*+ recompile */ * from participant2__p__before_2000 where log10(gold)>0;

drop table participant2;


