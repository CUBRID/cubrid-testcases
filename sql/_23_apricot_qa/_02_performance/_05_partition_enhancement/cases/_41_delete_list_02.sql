drop table if exists t;
drop table if exists temp;
drop table if exists t__p__p101;
drop table if exists t__p__p102;

create table t(t timestamp,v varchar(100)) partition by list(last_day(t)) (
partition p0 values in ('1970-3-31'),
partition p1 values in ('1971-2-28'),
partition p2 values in ('1972-2-29'),
partition p3 values in ('1973-10-31','1973-11-30'),
partition p4 values in ('1974-03-31','1975-03-31','1976-2-29'),
partition p5 values in ('1977-11-30'),
partition p6 values in ('1978-9-30','1979-10-31','1980-10-31'),
partition p7 values in ('1981-1-31'),
partition p8 values in ('1982-3-31'),
partition p9 values in ('1983-09-30'),
partition p10 values in ('1984-2-29'),
partition p11 values in ('1985-2-28','1986-1-31','1987-2-28','1988-3-31','1989-3-31'),
partition p12 values in ('1990-1-31'),
partition p13 values in ('1991-2-28'),
partition p14 values in ('1992-7-31'),
partition p15 values in ('1993-2-28'),
partition p16 values in ('1994-06-30','1995-10-31','1996-12-31','1997-11-30','1998-11-30','1999-12-31'),
partition p17 values in ('2000-2-29'),
partition p18 values in ('2001-2-28'),
partition p19 values in ('2012-2-29'));

create table temp(t timestamp);
insert into temp values('1970-3-10 23:12:09'),('1971-2-01 12:00:00 PM'),('1972-2-19 12:59:59'),('1973-10-11 11:11:11 AM'),('1973-10-12 03:12:15 PM'),('1974-03-22'),('1975-03-21'),('1976-2-28'),('1977-11-12'),('1978-9-9'),('1979-10-10'),('1980-10-10'),('1981-1-19'),('1982-3-26'),('1983-09-09'),('1984-2-28'),('1985-2-28'),('1986-1-1'),('1987-2-2'),('1988-3-21'),('1989-3-31'),('1990-1-1'),('1991-2-15'),('1992-7-7 02:02:02'),('1993-2-14'),('1994-06-06'),('1995-10-11'),('1996-12-24'),('1997-11-01'),('1998-11-30'),('1999-12-31'),('2000-2-29'),('2001-2-28'),('2012-2-29 11:00:01');

insert into temp values('1971-2-21 12:00:05 AM');
insert into t select t,cast(t as varchar) from temp;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;

select t,count(*) from t__p__p11 group by t order by 1;

alter table t reorganize partition p1 into (partition p101 values in ('02/28/1971'),partition p102 values in('02/29/1972'));
alter table t reorganize partition p1 into (partition p101 values in ('02/28/1971'),partition p102 values in('02/29/2004'));
alter table t reorganize partition p101 into (partition p101 values in ('02/28/1971','02/29/2008'));
insert into t values('02/28/2004 12:00:00 AM',NULL);
update t set t = '12:00:00 AM 02/28/2008' where t = '12:00:00 AM 02/28/2004';

select * from db_partition where class_name='t' order by 2;
select * from db_class where class_name='t' or class_name like 't__p__p%' order by 1;

select distinct t from t__p__p101 order by 1 ;
select distinct t from t__p__p102 order by 1 ;

alter table t promote partition p101,p102;
delete from t where last_day(t) in ('02/28/1971','1984-2-29') or last_day(t)< '1972-2-29';

select t, count(*) from t__p__p101 group by t order by 1;

drop t__p__p101;
drop t__p__p102;
drop t;
drop temp;
