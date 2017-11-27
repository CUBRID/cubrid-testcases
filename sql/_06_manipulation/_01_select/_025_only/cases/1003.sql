--Test only in common class
create class t1 (col1 int, col2 char(2));


insert into t1 values(1, 'x');
insert into t1 values(2, 'y');


select * from only t1 order by 1;
select * from all t1 order by 1;

drop class t1;
