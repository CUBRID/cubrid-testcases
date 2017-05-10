drop table if exists t;
create table t(col1 int,col2 varchar(20),col3 date);
insert into t values(1,'book1','2007-12-24');
insert into t values(2,'book2','2008-12-24');
insert into t values(3,'book3','2009-12-24');
insert into t values(4,'book4','2010-12-24');
insert into t values(5,'book2','2008-12-24');
insert into t values(6,'book2','2011-12-24');
insert into t values(7,'book5','2008-12-24');
CREATE INDEX idx1 ON t(year(col3),col1);
CREATE INDEX idx2 ON t(col2,col1);
CREATE INDEX idx3 ON t(year(col3),col2,col1);

drop table if exists x;
create table x(col1 int,col2 varchar(20),col3 date);


insert into x select /*+ recompile */* FROM t
WHERE year(col3)=2008 and col2='book2' ;
select * from x order by 1,2,3;

insert into x select * FROM t
WHERE year(col3)=2008 and col2='book2' using index idx1(+) keylimit 0+0+0+0+0+0+0,1-1+1;
select * from x order by 1,2,3;

insert into x select *
FROM t
WHERE year(col3)=2008 and col2='book2' using index idx2(+) keylimit 2-(2*1),1;
select * from x order by 1,2,3;
insert into x select *
FROM t
WHERE year(col3)=2008 or col2='book2' using index idx2(+) keylimit 1*(2-2),3;
select * from x order by 1,2,3;
insert into x select *
FROM t
WHERE year(col3)=2008 or col2='book2' using index idx1(+) keylimit 0,3;
select * from x order by 1,2,3;
drop table if exists t,x;
