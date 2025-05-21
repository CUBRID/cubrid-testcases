drop table if exists t;
drop table if exists temp;
drop table if exists t__p__p16;

create table t(t timestamp,id int auto_increment(2,3),v varchar(100)) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'),
partition p3 values in ('1973-10-11','1973-10-12'),
partition p4 values in ('1974-03-22','1975-03-21','1976-2-28'),
partition p5 values in ('1977-11-12'),
partition p6 values in ('1978-9-9','1979-10-10','1980-10-10'),
partition p7 values in ('1981-1-19'),
partition p8 values in ('1982-3-26'),
partition p9 values in ('1983-09-09'),
partition p10 values in ('1984-2-28'),
partition p11 values in ('1985-2-28','1986-1-1','1987-2-2','1988-3-21','1989-3-31'),
partition p12 values in ('1990-1-1'),
partition p13 values in ('1991-2-15'),
partition p14 values in ('1992-7-7'),
partition p15 values in ('1993-2-14'),
partition p16 values in ('1994-06-06','1995-10-11','1996-12-24','1997-11-01','1998-11-30','1999-12-31'),
partition p17 values in ('2000-2-29'),
partition p18 values in ('2001-2-28'),
partition p19 values in ('2012-2-29'));

create table temp(t timestamp);
insert into temp values('1970-3-10'),('1971-2-01'),('1972-2-19'),('1973-10-11'),('1973-10-12'),('1974-03-22'),('1975-03-21'),('1976-2-28'),('1977-11-12'),('1978-9-9'),('1979-10-10'),('1980-10-10'),('1981-1-19'),('1982-3-26'),('1983-09-09'),('1984-2-28'),('1985-2-28'),('1986-1-1'),('1987-2-2'),('1988-3-21'),('1989-3-31'),('1990-1-1'),('1991-2-15'),('1992-7-7'),('1993-2-14'),('1994-06-06'),('1995-10-11'),('1996-12-24'),('1997-11-01'),('1998-11-30'),('1999-12-31'),('2000-2-29'),('2001-2-28'),('2012-2-29');

insert into t select t,NULL,cast(t as varchar) from temp;
--insert into t select * from t; 
--insert into t select * from t; 
--insert into t select * from t; 
--insert into t select * from t; 
--insert into t select * from t; 
insert into t select t,NULL,cast(t+1 as varchar) from t;
insert into t select t,NULL,cast(t+2 as varchar) from t;
insert into t select t,NULL,cast(t+3 as varchar) from t;
insert into t select t,NULL,cast(t+4 as varchar) from t;
insert into t select t,NULL,cast(t+5 as varchar) from t;



select * from db_partition where class_name='t' order by partition_name;
select * from db_class where class_name='t';

select t,count(*) from t__p__p16 group by t order by 1;

alter table t promote partition t;
alter table t promote partition p16;
alter table t add column i int;
create unique index ui on t(t,id,v);
create reverse index ri1 on t(last_day(t));
create reverse index ri2 on t__p__p16(last_day(t));

select * from db_partition where class_name='t' order by partition_name;
select * from db_class where class_name='t' or class_name like 't__p__p%' order by 1;

update statistics on all classes;
show columns from t;
show index from t;
show index from t__p__p16;

alter table t__p__p16 partition by list(t)  (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'),
partition p3 values in ('1973-10-11','1973-10-12'),
partition p4 values in ('1974-03-22','1975-03-21','1976-2-28'),
partition p5 values in ('1977-11-12'),
partition p6 values in ('1978-9-9','1979-10-10','1980-10-10'),
partition p7 values in ('1981-1-19'),
partition p8 values in ('1982-3-26'),
partition p9 values in ('1983-09-09'),
partition p10 values in ('1984-2-28'),
partition p11 values in ('1985-2-28','1986-1-1','1987-2-2','1988-3-21','1989-3-31'),
partition p12 values in ('1990-1-1'),
partition p13 values in ('1991-2-15'),
partition p14 values in ('1992-7-7'),
partition p15 values in ('1993-2-14'),
partition p16 values in ('1994-06-06','1995-10-11','1996-12-24','1997-11-01','1998-11-30','1999-12-31'),
partition p17 values in ('2000-2-29'),
partition p18 values in ('2001-2-28'),
partition p19 values in ('2012-2-29'));

delete from t__p__p16;

insert into t__p__p16 select t,NULL,cast(t as varchar) from temp;
--insert into t select * from t; 
insert into t(t,id,v) select t,NULL,cast(t+6 as varchar) from t;

update statistics on all classes;
drop reverse index ri2 on t__p__p16(last_day(t));
show index from t__p__p16;
show columns from t__p__p16;

prepare st from 'delete from t where t in (?,?) or t < ?';
execute st using '1985-2-28','1993-2-14','1972-2-19';
deallocate prepare st;

select count(*) from t where t in ('1985-2-28','1993-2-14','1972-2-19');

drop t;
drop temp;
drop t__p__p16;



















