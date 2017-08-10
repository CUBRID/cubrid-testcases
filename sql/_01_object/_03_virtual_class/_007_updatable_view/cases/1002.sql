-- [er] create class,create vclass based on the created class,select data from the no updatable vclass,then reprot error,'Only updatable vclasses are allowed to select VIDs'

create class view_test1 ( id int, id_key int, id_s string );
create class view_test2 ( id int, id_key int, id_s string );
insert into view_test1 values( 1, 1, 'test1');
insert into view_test1 values( 2, 2, 'test2');
insert into view_test1 values( 3, null, 'test3');
insert into view_test1 values( 4, null, 'test4');
insert into view_test1 values( 5, null, 'test5');

insert into view_test2 values( 1, null, 'test1');
insert into view_test2 values( 2, null, 'test2');
insert into view_test2 values( 3, 3, 'test3');
insert into view_test2 values( 4, 4, 'test4');
insert into view_test2 values( 5, 5, 'test5');

create vclass updatable_view_test as 
                   select * from view_test1 where id between 3 and 5;
create vclass non_updatable_view_test as 
                   select a.id, a.id_key, b.id_s from view_test1 a , view_test2 b
                   where a.id between 3 and 5 and a.id = b.id;

select updatable_view_test from updatable_view_test;
select non_updatable_view_test from non_updatable_view_test;



drop class view_test1;
drop class view_test2;
drop vclass updatable_view_test;
drop vclass non_updatable_view_test;