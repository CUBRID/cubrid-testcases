autocommit off;
create class discounts(d_discount numeric(6,2), d_begin_range int, d_end_range int);
insert into discounts (d_discount, d_begin_range, d_end_range)
values (00.00, 0, 999);
insert into discounts (d_discount, d_begin_range, d_end_range)
values (05.00, 1000, 2499);
insert into discounts (d_discount, d_begin_range, d_end_range)
values (10.00, 2500, 4999);
insert into discounts (d_discount, d_begin_range, d_end_range)
values (20.00, 5000, 10000000);
select * from discounts;
rollback;
