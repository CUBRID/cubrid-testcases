--Test optimizing with multi class at one time
create class t1(x int, y char(10));
create class t2(x int, y char(10));
create class t3(x int, y char(10));

insert into t1 values(101, 'x');
insert into t1 values(102, 'y');
insert into t1 values(103, 'z');
insert into t1 values(104, 'a');

insert into t2 values(101, 'x');
insert into t2 values(102, 'y');
insert into t2 values(103, 'z');
insert into t2 values(104, 'a');

insert into t3 values(101, 'x');
insert into t3 values(102, 'y');
insert into t3 values(103, 'z');
insert into t3 values(104, 'a');


select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

update statistics on t1, t2, t3;

select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

drop class t1, t2, t3;
