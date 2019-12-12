create table t(i int);
insert into t values(10);
alter table t partition by range(i) (partition p0 values less than(5));
drop t;

create table t(i int);
insert into t values(10);
alter table t partition by list(i) (partition p0 values in (1,2,3),partition p1 values in (5,6,7));
drop t;

create table t(d date);
insert into t values('2012-7-5');
alter table t partition by list(weekday(d)) (partition p0 values in (0),partition p1 values in (1));
drop t;

create table t(i int auto_increment,d date primary key);
create serial s;
insert into t values (NULL,adddate('2000-2-28',s.next_value));
insert into t values (NULL,adddate('2000-2-28',s.next_value));
alter table t partition by range(month(d)) (partition p0 values less than(2),partition p1 values less than (3));
delete from t;
insert into t values (NULL,adddate('2000-2-20',s.next_value));
alter table t partition by range(month(d)) (partition p0 values less than(2),partition p1 values less than (3));
drop t;
drop serial s;