autocommit off;
create class foo (i int, s string, j int, t string, x int);
insert into foo values (1, '1', 10, '10', 100);
insert into foo values (2, '2', 20, '20', 200);
insert into foo values (3, '3', 30, '30', 300);
insert into foo values (4, '4', 40, '40', 400);
insert into foo values (5, '5', 50, '50', 500);
insert into foo values (6, '6', 60, '60', 600);
insert into foo values (7, '70', 70, '70', 700);
insert into foo values (8, '80', 80, '80', 800);
insert into foo values (9, '90', 90, '90', 900);
insert into foo values (10, '100', 10, '100', 1000);

create unique index foo_uidx on foo(i, s, j, t);
create index foo_idx on foo (i, j);
create index foo_idx2 on foo (s, t);
select *
 from foo
 using index foo_idx; 
select *
  from foo
 where i = 5 and j = 50; 
select *
  from foo
 where i = 5 and j = 50
 using index foo_idx; 
select *
  from foo
 where s = '5' and t = '50'
 using index foo_uidx, foo_idx; 
select *
  from foo
 where i = 5 and s = '5'; 
select *
  from foo
 where i = 5 and s = '5'
 using index foo_idx2; 
select *
  from foo
 where i = 5 and s = '5' and j = 50 and t = '50'
 using index none; 
select *
  from foo
 where i = 5 and s = '5' and j = 50 and t = '50'
 using index foo_uidx, foo_idx, foo_idx2;
drop index foo_idx2 on foo;
drop index foo_idx on foo;
drop unique index foo_uidx on foo(i, s, j, t);
rollback;
