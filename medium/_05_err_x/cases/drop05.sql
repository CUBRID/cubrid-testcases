autocommit off;

insert into joe.product_c(product_code, descr)
values (10, 'foo') to p1;
drop variable p1;
insert into joe.inventory_c(product, quantity)
values (p1, 1000);
rollback work;
rollback;
