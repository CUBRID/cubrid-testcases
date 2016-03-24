--+ holdcas on;
--Create class with null and default , then retrive from db_class
call login ('dba') on class db_user;
create class t1 (
c1 int DEFAULT 9  null 
);

select * from db_class
where class_name = 't1';

drop class t1;
--+ holdcas off;
