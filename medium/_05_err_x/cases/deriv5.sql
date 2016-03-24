autocommit off;
select ssn, n from (select ssn from faculty g where f = g) h (n), faculty1 f;
rollback;
