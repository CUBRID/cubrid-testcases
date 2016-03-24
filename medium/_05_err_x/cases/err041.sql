autocommit off;

create vclass co_1_1_c
method co_1_1_met(int,float,int,double,date,time,monetary) string
function impl_sd_6_1_met
file 'impl_test_methods.o';
select * from co_1_1_c c;
rollback;
