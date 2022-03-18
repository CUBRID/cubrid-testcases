autocommit off;
select class [joe.faculty1], max(ssn) from joe.faculty1;
rollback;
