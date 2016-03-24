autocommit off;
create class class_a ( a int );
create class class_b ( b class_a );
insert into class_b values (
insert into class_a values ( 1 ) );
create class class_e ( e int );
insert into class_e values (1);
create trigger tri_test
before delete on class_b
if 0 < (select count( e ) from class_e where e = obj.b.a)
execute reject;
delete from class_b where b.a = 1;
select b.a from class_b;
rollback;
