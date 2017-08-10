create table t (a char(10), b varchar(1200),c date, d time, e timestamp);

create index idx1 on t(adddate(a, 1));
create index idx2 on t(adddate(b, 1));
create index idx3 on t(adddate(c, 1.1));
create index idx4 on t(adddate(c, -1));
create index idx5 on t(adddate(c, interval 1 hour));

create index idx6 on t(subdate(a, 1));
create index idx7 on t(subdate(b, 1));
create index idx8 on t(subdate(c, 1.1));
create index idx9 on t(subdate(c, -1));
create index idx10 on t(subdate(c, interval 1 hour));

-- also will work
create index idx11 on t(adddate(d, 1));
create index idx12 on t(adddate(e, 1));

insert into t (c) values ('2009-02-01'), ('2010-01-01'), ('2011-03-04');

select c from t where adddate(c, interval 1 hour) > '2010-01-01' using index idx5;

drop t;