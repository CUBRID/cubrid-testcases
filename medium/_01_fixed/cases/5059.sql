autocommit off;
create class soshiki (gid char(9), usp set_of(soshiki) default {});
create class usr ( sp set_of(soshiki) default {});
create class ufield1 (up usr);
create class sys_usr as subclass of usr ( uf1p set_of(ufield1) default
{});
SELECT MULTISET(SELECT S2.gid FROM TABLE(UFP.up.sp) AS TS1(S1),
       TABLE(S1.USP) AS TS2(S2)  WHERE EXISTS S1.USP )
   FROM sys_usr P, TABLE(P.uf1p) AS TF(UFP);
select MULTISET(SELECT S1.GID FROM TABLE(UFP.up.sp) AS TS1(S1)
        WHERE EXISTS UFP.up.sp)
   FROM sys_usr P, TABLE(P.uf1p) AS TF(UFP);
create class test_class1 ( attr1 set_of(int) );
create class test_class2 ( attr2 test_class1 );
insert into test_class2 values ( NULL );
select * from test_class2 where exists attr2.attr1;
rollback work;
rollback;
