autocommit off;
create class foo(a1 date, a2 time);
insert into foo(a1, a2) values(DATE '7/19/93', TIME '4:00');
select * from foo where a1 in {DATE '07/19/93'} or a2 in {TIME ' 04:00:00 AM'};
select * from foo where a1= DATE '07/19/93' and a2= TIME ' 04:00:00 AM';
rollback;
