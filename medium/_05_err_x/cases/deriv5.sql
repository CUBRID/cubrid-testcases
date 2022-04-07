autocommit off;
select ssn, n from (select ssn from joe.faculty g where f = g) h (n), joe.faculty1 f;
rollback;
