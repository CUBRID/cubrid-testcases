drop table if exists t;
drop table if exists temp;
create table t(d date) partition by range(extract(year from d)) (
partition p0 values less than ('1980'),
partition p1 values less than ('2000'),
partition p2 values less than maxvalue);
create table temp(d date);
insert into temp values('1970-3-10'),('1971-2-01'),('1972-2-19'),('1973-10-11'),('1973-10-12'),('1974-03-22'),('1975-03-21'),('1976-2-28'),('1977-11-12'),('1978-9-9'),
('1979-10-10'),('1980-10-10'),('1981-1-19'),('1982-3-26'),('1983-09-09'),('1984-2-28'),('1985-2-28'),('1986-1-1');
insert into temp values('1987-2-2'),('1988-3-21'),('1989-3-31'),('1990-1-1'),('1991-2-15'),('1992-7-7'),('1993-2-14'),('1994-06-06'),('1995-10-11'),('1996-12-24'),
('1997-11-01'),('1998-11-30'),('1999-12-31'),('2000-2-29'),('2001-2-28'),('2012-2-29');
insert into t select * from temp;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
alter table t add column d2 date;
update t set d2=d;
update t set d=adddate(d2,5);

select case count(d) when 0 then 'ok' else 'nok' end from (select distinct d from t__p__p1 where extract(year from d) >='2000') t2;

drop t;
drop temp;

create table t(d date,d2 date) partition by range(extract(year from d)) (
partition p0 values less than ('1980'),
partition p1 values less than ('2000'),
partition p2 values less than maxvalue);
create table temp(d date);
insert into temp values('1970-3-10'),('1971-2-01'),('1972-2-19'),('1973-10-11'),('1973-10-12'),('1974-03-22'),('1975-03-21'),('1976-2-28'),
('1977-11-12'),('1978-9-9'),('1979-10-10'),('1980-10-10'),('1981-1-19'),('1982-3-26'),('1983-09-09'),('1984-2-28'),('1985-2-28'),('1986-1-1');
insert into temp values('1987-2-2'),('1988-3-21'),('1989-3-31'),('1990-1-1'),('1991-2-15'),('1992-7-7'),('1993-2-14'),('1994-06-06'),
('1995-10-11'),('1996-12-24'),('1997-11-01'),('1998-11-30'),('1999-12-31'),('2000-2-29'),('2001-2-28'),('2012-2-29');
insert into t select d,d from temp;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
insert into t select * from t;
update t set d=adddate(d2,5);
alter table t promote partition p2;
alter table t__p__p2 partition by range (extract(year from d)) (
partition p0 values less than ('1980'),
partition p1 values less than ('2000'),
partition p2 values less than maxvalue);
select case count(d) when 0 then 'ok' else 'nok' end from (select distinct d from t__p__p2__p__p1 where extract(year from d) >='2000') t2;

drop t;
drop temp;
drop t__p__p2;




