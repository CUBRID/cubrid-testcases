-- vclass is unupdatable if select using path expression

create class c1 ( id int, id_key int, id_s string );

insert into c1 values( 1, 1, 'test1');
insert into c1 values( 2, 2, 'test2');
insert into c1 values( 3, null, 'test3');
insert into c1 values( 4, null, 'test4');
insert into c1 values( 5, null, 'test5');

insert into c1 values( 5, 5, 'test5');


select c1 INTO a from c1 where id=1;

CREATE class c2 (
col1 c1
); 

insert INTO c2 VALUES (a);

create vclass v1 as 
                   select col1.id FROM c2;

SELECT * FROM v1;

select v1 from v1;



drop class c1,c2;
drop vclass v1;