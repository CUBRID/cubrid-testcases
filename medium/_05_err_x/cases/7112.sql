autocommit off;

create class b under a ( id int );
create class c under a ( id int );
select * from all a;
rollback;
