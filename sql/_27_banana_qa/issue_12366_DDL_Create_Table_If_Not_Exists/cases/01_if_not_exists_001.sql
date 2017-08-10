--01_if_not_exists_001.sql
--class
--clean up
drop class if exists t12366;
drop class if exists t12366_lk;
drop class if exists t12366_lk2;
drop class if exists t12366_as;

--scenario 1: general
drop class if exists t12366;
create class t12366(a varchar(10), b int not null);
drop class t12366;
create class if not exists t12366(a varchar(10), b int not null);
desc t12366;
--run this command again, should success
create class if not exists t12366(a varchar(11), b int not null);
desc t12366;

--create a different class, should keep the old one
create class if not exists t12366(c date default sysdate);
desc t12366;


--scenario 2: create like another class
create class if not exists t12366_lk like t12366;
desc t12366_lk;
create class if not exists t12366_lk like t12366_lk;
desc t12366_lk;

--scenario 3: create like another class with ()
create class if not exists t12366_lk2 (like t12366);
desc t12366_lk2;
--execute it again, should success
create class if not exists t12366_lk2 (like t12366_lk2);
desc t12366_lk2;

--scenario 4: create as
insert into t12366 values('lex', 12366);
create class if not exists t12366_as as select a from t12366;
--check class
select * from t12366_as order by 1;
insert into t12366_as values ('bts');

--execute it again, should success
create class if not exists t12366_as as select a from t12366;
--check class
select * from t12366_as order by 1;

--clean up
drop t12366;
drop t12366_lk;
drop t12366_lk2;
drop t12366_as;
