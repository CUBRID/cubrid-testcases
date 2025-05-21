--test union,difference, intersection

create class t1
( 	int_col int not null,
var_col varchar(20),
set_col set (int,varchar(20)));

create class t2 	
(	int_col int not null,
var_col varchar(20),
set_col set (int, varchar(20)));

create class t3 under t1
( 	int_col1 int not null);


insert into t1 values (1,'test1', {1,'test1'});
insert into t1 values (2,'test1', {1,'test1'});
insert into t1 values (3,'test2', {1,'test2'});
insert into t1 values (4,'test1', {2,'test1'});
insert into t1 values (5,'test2', {2,'test2'});


insert into t2 values (1,'test1', {1,'test1'});
insert into t2 values (2,'test1', {1,'test1'});
insert into t2 values (3,'test2', {1,'test2'});
insert into t2 values (4,'test1', {2,'test1'});
insert into t2 values (5,'test2', {2,'test2'});


insert into t3 values (1,'test1', {1,'test1'},1);
insert into t3 values (2,'test1', {1,'test1'},2);
insert into t3 values (3,'test2', {1,'test2'},3);
insert into t3 values (4,'test1', {2,'test1'},4);
insert into t3 values (5,'test2', {2,'test2'},5);




select int_col+1.0 from t1 union all select int_col+1.0 from t2 union all select int_col+1.0 from t3 order by 1;

prepare st from 'select int_col+? from t1 union all select int_col+? from t2 union all select int_col+? from t3 order by 1';
execute st using 1.0,1.0,1.0;
deallocate prepare st;

prepare st from 'select int_col+1.0 from t1 union all select int_col+? from t2 union all select int_col+? from t3 order by 1';
execute st using 1.0,1.0;
deallocate prepare st;



select int_col-1e0 from t1 intersection select int_col+1.0 from t2 order by 1;

prepare st from 'select int_col-? from t1 intersection select int_col+? from t2 order by 1';
execute st using 1e0,1.0;
deallocate prepare st;

prepare st from 'select int_col-? from t1 intersection select int_col+1.0 from t2 order by 1';
execute st using 1e0;
deallocate prepare st;


select 1+int_col from t1 difference all select '1' + int_col from t2 union all select '1'- int_col from t3  order by 1;

prepare st from 'select 1+int_col from t1 difference all select ? + int_col from t2 union all select ? - int_col from t3  order by 1';
execute st using '1',1.0;
deallocate prepare st;

drop class t1;
drop class t2;
drop class t3; 

