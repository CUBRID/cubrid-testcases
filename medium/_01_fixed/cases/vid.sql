--+ holdcas on;
autocommit off;
select p.ssn,q.ssn from joe.faculty p, joe.faculty1 q where p = q order by 1,2;-- 2 rows
select p.ssn,q.ssn  from joe.faculty p, joe.faculty1 q where q = p order by 1,2;-- test symmetry 
select p.ssn,q.ssn  from joe.faculty1 p, joe.faculty q where p = q order by 1,2;-- dotto
select p.ssn,q.ssn  from joe.faculty1 p, joe.faculty q where q = p order by 1,2; -- ditto
select p.ssn,q.ssn  from joe.faculty1 p, joe.faculty q where p <> q  order by 1,2;
select p.ssn,q.ssn  from joe.faculty1 p, joe.faculty q where q <> p  order by 1,2;
/* this should produce 7 rows */
select p, ssn from joe.faculty p where p in (select q from joe.faculty q) order by 2;
/* the p = q test appears to always pass */
select p.ssn,q.ssn from joe.faculty p, joe.faculty q where p = q  order by 1,2;
select f into p7 from joe.faculty f where ssn = 7 order by 1;
select f from joe.faculty f where f = p7 order by 1;
rollback;

--+ holdcas off;
