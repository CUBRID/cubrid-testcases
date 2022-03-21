autocommit off;
select ssn1 from (select ssn from joe.faculty1) f (ssn1);
select ssn from joe.faculty1 f, (select ssn from joe.faculty g where f = g) h (ssn);
rollback;
