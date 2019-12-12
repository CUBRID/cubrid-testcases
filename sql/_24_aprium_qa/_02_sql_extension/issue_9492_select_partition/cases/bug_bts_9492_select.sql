create table t(i int) partition by hash(i) partitions 5;

insert into t select rownum from _db_class limit 40;

select i from t partition (p0) order by i;
select i from t partition (p1) order by i;

drop table t;

create table t(i int) partition by list(i) (
	partition p0 values in (1, 2, 3),
	partition p1 values in (4, 5, 6),
	partition p2 values in (7, 8, 9)
);

insert into t select rownum from _db_class limit 9;

select a.i as p0i, b.i as p2i from t partition (p0) a, t partition (p2) b where a.i = b.i - 6 order by a.i;

select a.i, b.i from t a, t partition (p1) b where a.i = b.i order by 1, 2;

select a.i, b.i from t a, t partition (p1) b where a.i = b.i order by 1, 2;

select a.i, b.i from t partition (p1) a, t b where a.i = b.i order by 1, 2;

select a.i, b.i, c.i from t a, t partition (p1) b inner join t partition (p2) c on c.i = b.i where a.i = c.i order by 1, 2, 3;

select a.i, b.i, c.i from t partition (p1) a, t b inner join t partition (p2) c on c.i = b.i where a.i = b.i order by 1, 2, 3;

drop table t;

create table t(i int) partition by list(i) (
	partition p0 values in (1, 2, 3),
	partition p1 values in (4, 5, 6),
	partition p2 values in (7, 8, 9)
);

create table u (i int);
insert into t select rownum from _db_class limit 9;
insert into u select rownum from _db_class limit 9;

select t.i, u.i from t partition (p0) t, u where t.i = u.i - 6 order by t.i;

select t.i, u.i from t partition (p0) t inner join u on t.i = u.i - 6 order by t.i;

select t.i, u.i from t partition (p0) t left join u on t.i = u.i - 6 order by t.i;

select t.i, u.i from t partition (p0) t right join u on t.i = u.i - 6 order by u.i;

select t.i, u.i from u right join t partition (p0) on t.i = u.i - 6 order by u.i;

select t.i, u.i from u left join t partition (p0) t on t.i = u.i - 6 order by u.i;

select t.i, u.i from u, t partition (p0) t where t.i = u.i - 6 order by t.i;

drop table u;
drop table t;

create table t(i int) partition by list(i) (
	partition p0 values in (1, 2, 3),
	partition p1 values in (4, 5, 6),
	partition p2 values in (7, 8, 9)
);

create table u (i int);
insert into t select rownum from _db_class limit 9;
insert into u select rownum from _db_class limit 9;

select * from u partition (p0) order by i;

select * from t partition (p15) order by i;

select * from t partition (p0, p1) order by i;

select * from t partition () order by i;

select * from (select * from t) partition (p0) order by i;

create view v as select * from u;

select * from t partition (p0), u t order by i;

select * from t partition (p0), v t order by i;

drop view v;
drop table t;
drop table u;
