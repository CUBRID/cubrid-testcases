--Test insert data with object domain
create class t1(c1 integer, c2 char(1));
create class t2(c1 integer, c2 t1);

insert into t1 values(1, 'a');
insert into t1 values(2, 'b');
insert into t1 values(3, 'c');
insert into t1 values(4, 'd');
insert into t1 values(5, 'e');

insert into t2 values(1, insert into t1 values(6,'g'));
insert into t2 values(2, insert into t1 values(7,'h'));


select * from t1 order by 1;
select c1,c2.c1,c2.c2 from t2 order by 1;

drop class t1;
drop class t2;
