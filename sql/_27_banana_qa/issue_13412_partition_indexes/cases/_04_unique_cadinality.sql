drop table if exists t;
create table t(i int ) partition by range(i)
(
partition p0 values less than (5),
partition p1 values less than (25),
partition p2 values less than (35),
partition p3 values less than (45)
);
insert into t values(1),(2),(3),(4);
insert into t values(21),(22),(23),(24);
insert into t values(31),(32),(33),(34);
insert into t values(41),(42),(43),(44);
create index idx_local on t(i);
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;

show index in t__p__p1;
show index in t__p__p2;
show index in t__p__p3;
drop table if exists t;
create table t(i int unique ) partition by range(i)
(
partition p0 values less than (5),
partition p1 values less than (25),
partition p2 values less than (35),
partition p3 values less than (45)
);
insert into t values(1),(2),(3),(4);
insert into t values(21),(22),(23),(24);
insert into t values(31),(32),(33),(34);
insert into t values(41),(42),(43),(44);
create index idx_local on t(i);
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;

show index in t__p__p1;
show index in t__p__p2;
show index in t__p__p3;


drop table if exists t;
create table t(i int ,j char(2) ,unique(i,j) ) partition by range(i)
(
partition p0 values less than (5),
partition p1 values less than (25),
partition p2 values less than (35),
partition p3 values less than (45)
);
insert into t(i) values(1),(2),(3),(4);
insert into t(i) values(21),(22),(23),(24);
insert into t(i) values(31),(32),(33),(34);
insert into t(i) values(41),(42),(43),(44);
create unique index idx_local on t(i);
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;

show index in t__p__p1;
show index in t__p__p2;
show index in t__p__p3;

drop table if exists t;
create table t(i int ,j char(2) ,unique(i,j) ) partition by range(i)
(
partition p0 values less than (5),
partition p1 values less than (25),
partition p2 values less than (35),
partition p3 values less than (45)
);
insert into t(i) values(1),(2),(3),(4);
insert into t(i) values(21),(22),(23),(24);
insert into t(i) values(31),(32),(33),(34);
insert into t(i) values(41),(42),(43),(44);
alter table t add constraint pk_t_i primary key t(i);
update statistics on t with fullscan;
show index in t;
show index in t__p__p0;

show index in t__p__p1;
show index in t__p__p2;
show index in t__p__p3;
drop table t;




