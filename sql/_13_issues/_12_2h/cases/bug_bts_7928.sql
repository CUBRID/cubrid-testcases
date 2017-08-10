drop table if exists t ;
drop vclass v;

create class t(a int primary key,b varchar(10));
create vclass v(a,b,c) as select a,b, ('aaa'='aaa') c from t;

select  * from v;

drop table if exists t ;
drop vclass v;
