--+ holdcas on;
autocommit off;
create vclass foo as select name from db_user;
select foo into p2 from foo where foo.name = 'DBA';
select {p2} from class db_user; 
rollback;

--+ holdcas off;
