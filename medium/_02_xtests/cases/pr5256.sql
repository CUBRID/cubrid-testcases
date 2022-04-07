autocommit off;
select 	descr from   joe.inventory_c i, joe.product_c p
where descr = (select descr from class db_user)
and p = i.product;
select 	descr from   joe.inventory_c i, joe.product_c p
where p = i.product
and descr = (select descr from class db_user);
rollback;
