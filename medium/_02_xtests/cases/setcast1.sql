autocommit off;
select cast(seq3 as set varchar(20)) from xseta where i<4;
rollback;
