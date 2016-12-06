--Test except with superclass
create class t1 (col1 int, col2 char(2));
create class sub_t1 as subclass of t1
(col3 int, col4 char(2));

insert into t1 values(1, 'x');
insert into t1 values(2, 'y');
select * from t1 order by 1;
select * from sub_t1 order by 1;
insert into sub_t1 values(1, 'x', 2,'a');
insert into sub_t1 values(2, 'y', 3,'c');
insert into sub_t1 values(3, 'z', 4,'b');


select * from t1 order by 1;
select * from all t1 (except sub_t1) order by 1;

drop class t1;
drop class sub_t1;
