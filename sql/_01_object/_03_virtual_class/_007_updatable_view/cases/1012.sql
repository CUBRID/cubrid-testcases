-- [er] vclass is unupdatable if select using operation -

create class c1 ( id int, id_key int, id_s string );

insert into c1 values( 1, 1, 'test1');
insert into c1 values( 2, 2, 'test2');
insert into c1 values( 3, null, 'test3');
insert into c1 values( 4, null, 'test4');
insert into c1 values( 5, null, 'test5');

insert into c1 values( 5, 5, 'test5');

create vclass v1 as 
                   select id-1 from c1 where id between 3 and 5;

SELECT * FROM v1;

select v1 from v1;



drop class c1;
drop vclass v1;