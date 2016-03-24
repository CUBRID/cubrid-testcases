autocommit off;
create class A (i int )
    method class set_cost(string, string) function qo_set_cost;
create index i_a_i on A(i);
create class B under A;
insert into A values (1);
insert into B values (2);
select count(*) from all A where i = 2;
drop B;
select count(*) from all A where i = 2;
insert into A values (2);
rollback work;
create class A (i int unique)
   method class set_cost(string, string) function qo_set_cost;
create class B under A;
insert into A values (1);
insert into B values (2);
select count(*) from all A where i = 2;
drop B;
select count(*) from all A where i = 2;
insert into A values (2);
rollback work;
create class A (i int unique) 
    method class set_cost(string, string) function qo_set_cost;
create class B under A;
insert into A values (1);
insert into B values (2);
select count(*) from all A where i = 2;
drop B;
select count(*) from all A where i = 2;
insert into A values (2);
rollback work;
rollback;
