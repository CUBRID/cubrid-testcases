autocommit off;
--set optimization: level 257
select count(*) from med,big where med.b=big.b;
rollback;
