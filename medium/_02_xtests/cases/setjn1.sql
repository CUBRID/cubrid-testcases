autocommit off;
--set optimization: level 257;
select a.i,b.i from xseta a, xseta b where a.set1=b.set1;
select a.i,b.i from xseta a, xseta b where a.mset2=b.mset2;
select a.i,b.i from xseta a, xseta b where a.seq3=b.seq3;
select a.i,b.i from xseta a, xseta b where a.seq3=b.mset2;
rollback;
