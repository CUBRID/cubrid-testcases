--create class with collection type attribute and change it's default value
create class t1(c1 int, c2 set varchar(10) default {'aaa','bbb'});

insert into t1(c1) values(101);
insert into t1(c1) values(102);
insert into t1(c1) values(103);
select * from t1 order by 1,2;
alter t1 modify c2 set varchar(10) default {'zz','yy'};
select * from t1 order by 1,2;
insert into t1(c1) values(104);
insert into t1(c1) values(105);
insert into t1(c1) values(106);
select * from t1 order by 1,2;
drop class t1;