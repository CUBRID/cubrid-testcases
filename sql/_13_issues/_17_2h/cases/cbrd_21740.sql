drop table if exists t1;
create table t1 (a int, b json);
create index i1 on t1(a) where a>0 and b=json_object('a', 1);
create index i2 on t1(b);
create index i3 on t1(a) where a>0 and b<0;
create index i4 on t1(a) where json_length(b) > a;
create index i5 on t1(a) where a>0 and json_valid(b)=1;
drop index i3 on t1;
create index i6 on t1(a) where a>0 and b is not null;
drop index i6 on t1;
create index i7 on t1(a asc) where a>a+1 and concat(b,b);

drop table if exists t1;
create table t1 (a int, b string);
create index i1 on t1(a) where a>0 and b=elt(1, 'a');

drop table if exists t1;
