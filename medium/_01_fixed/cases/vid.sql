autocommit off;
select p.ssn,q.ssn from faculty p, faculty1 q where p = q order by 1,2;-- 2 rows
select p.ssn,q.ssn  from faculty p, faculty1 q where q = p order by 1,2;-- test symmetry 
select p.ssn,q.ssn  from faculty1 p, faculty q where p = q order by 1,2;-- dotto
select p.ssn,q.ssn  from faculty1 p, faculty q where q = p order by 1,2; -- ditto
select p.ssn,q.ssn  from faculty1 p, faculty q where p <> q  order by 1,2;
select p.ssn,q.ssn  from faculty1 p, faculty q where q <> p  order by 1,2;
/* this should produce 7 rows */
select p, ssn from faculty p where p in (select q from faculty q) order by 2;
/* the p = q test appears to always pass */
select p.ssn,q.ssn from faculty p, faculty q where p = q  order by 1,2;
select f into p7 from faculty f where ssn = 7 order by 1;
select f from faculty f where f = p7 order by 1;
rollback;
