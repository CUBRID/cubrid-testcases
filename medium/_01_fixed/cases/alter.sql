autocommit off;
alter employees_v drop attribute ssn;
rollback work;
/* to drop a method */
alter vclass employee_u drop method rating;
rollback work;
/* add attribute */
alter product_c add attribute i integer;
create class ccc class attribute (ca int default 7, cb dec default 3.14) (a string);
insert into ccc(a) values('one');
select * from class ccc;
alter class ccc drop class ca;
select * from class ccc;
rollback work;
alter class employee_c drop attribute ssn;
rollback work;
rollback;
