autocommit off;
insert into product_c select product_code+10, descr, price from product_c;
insert into product_c select product_code+20, descr, price from product_c;
insert into product_c select product_code+40, descr, price from product_c;
insert into product_c select product_code+80, descr, price from product_c;
create index i_product_c_product_code on product_c(product_code);
select *
from product_c a
where a.product_code = (select b.product_code
			from product_c b
			where 4 = b.product_code)
select descr
from product_c
where product_code = (select product_code
		      from product_c
		      where 4 = product_code)
select *
from product_c a
where a.product_code = (select b.product_code
			from product_c b
			where b.product_code = a.product_code)
select *
from product_c a
where a.product_code = (select b.product_code
			from product_c b
			where a.product_code = b.product_code)
select a.descr
from product_c a, product_c b, product_c c
where a.product_code = b.product_code
and b.product_code = c.product_code
select a.descr
from product_c a, product_c b
where a.product_code = b.product_code
and b.product_code = 7
select a.descr
from product_c a, product_c b
where b.product_code = a.product_code
and b.product_code = 7
select a.descr
from product_c a, product_c b
where b.product_code = a.product_code
and a.product_code = 7
select a.descr
from product_c a, product_c b
where a.product_code = b.product_code
and a.product_code = 7
select a.descr
from product_c a, product_c b, product_c c
where a.product_code = b.product_code
and b.product_code = c.product_code
and c.product_code = 7
select a.descr
from product_c a, product_c b
where a.product_code = b.product_code + 10
and b.product_code = 7
rollback work;
rollback;
