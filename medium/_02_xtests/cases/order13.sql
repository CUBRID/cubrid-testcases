autocommit off;
select * from product_c a, product_c b
order by a.product_code, b.product_code;
rollback;
