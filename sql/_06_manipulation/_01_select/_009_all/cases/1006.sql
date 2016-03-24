--test all with null values

create class t1 (c1 int, c2 char(1));

insert into t1 values (1, 'x');
insert into t1 values (null, null);
insert into t1 values (2, 'x');
insert into t1 values (1, 'x');
insert into t1 values (null, 'y');
insert into t1 values (1, 'x');
insert into t1 values (null, null);
insert into t1 values (2, 'x');
insert into t1 values (1, 'x');
insert into t1 values (null, 'y');


select all c1 from t1 order by 1;
select all c2 from t1 order by 1;
select all c1, c2 from t1  order by 1,2;

drop class t1;