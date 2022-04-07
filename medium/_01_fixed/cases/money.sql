autocommit off;
create class x (m monetary, i int);
insert into x values (42,10);	-- This will lose the 10
insert into x values ($15,5);	-- This will keep the 5
select * from x order by 1;
rollback work;
select price / $10.00 from joe.product_c p order by 1;
select price * 7 from joe.product_c p order by 1;
select 2.71828 * price from joe.product_c p order by 1;
select price / 100.0 from joe.product_c p order by 1;
rollback;
