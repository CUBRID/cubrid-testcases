autocommit off;
evaluate cast ( 99 as bit(40));
evaluate cast ({ 99} as set bit(40));
select cast (seq3 as set bit(40)) from xseta where i=4;
rollback;
