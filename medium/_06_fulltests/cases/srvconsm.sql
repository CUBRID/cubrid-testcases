autocommit off;
--set optimization: level 257
create index i_big_b on big(b);
select count(1) from med,big where med.b=big.b;
rollback;
