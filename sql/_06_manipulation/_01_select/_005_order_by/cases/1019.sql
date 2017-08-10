--Test order by in virtual view

create class t1(id integer, name varchar(20), birthday date, dept_id integer);


insert into t1 values(1001, 'a', date'10/11/1980', 101);
insert into t1 values(1002, 'b', date'10/11/1980', 102);
insert into t1 values(1003, 'c', date'10/11/1981', 101);
insert into t1 values(1004, 'd', date'10/12/1980', 103);
insert into t1 values(1003, 'e', date'10/11/1981', 102);
insert into t1 values(1003, 'f', date'10/05/1982', 103);

create vclass v_t1 as select id, name from t1;

select * from  v_t1 
order by 1,2 desc;

drop class t1;
drop vclass v_t1;
