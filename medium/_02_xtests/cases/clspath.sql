autocommit off;
create class c (a int, me c);
insert into c(a) values(1) to :c1;
update object :c1 set me = :c1;
alter c add class attribute k c;
update class c set k = :c1;
select k, k.a from class c;
rollback;
