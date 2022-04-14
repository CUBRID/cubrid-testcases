--+ holdcas on;
autocommit off;
select p into :p1 from joe.faculty2 p where ssn = 7;
select p.ssn from table(set{:p1}) as t(p);
rollback;

--+ holdcas off;
