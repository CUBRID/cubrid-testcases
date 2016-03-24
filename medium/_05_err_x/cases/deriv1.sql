autocommit off;
select ssn1 from (select ssn from faculty1) f (ssn1)
select ssn from faculty1 f, (select ssn from faculty g where f = g) h (ssn)
rollback;
