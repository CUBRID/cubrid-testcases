autocommit off;

select product_code from product_c
where product_code <> '3';
rollback;
