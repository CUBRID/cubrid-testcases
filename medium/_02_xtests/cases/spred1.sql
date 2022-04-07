autocommit off;
select *
from joe.product_c p
where price between $10000 and $1000000 order by 1,2;
rollback;
