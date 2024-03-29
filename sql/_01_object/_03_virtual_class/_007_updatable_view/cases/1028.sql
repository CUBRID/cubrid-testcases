-- [er]vclass is unupdatable if select using inner join

create class c1 ( id int, id_key int, id_s string );

insert into c1 values( 1, 1, 'test1');
insert into c1 values( 2, 2, 'test2');
insert into c1 values( 3, null, 'test3');
insert into c1 values( 4, null, 'test4');
insert into c1 values( 5, null, 'test5');

insert into c1 values( 5, 5, 'test5');


CREATE class c2 (
id int,
name string
); 

insert INTO c2 VALUES (1,'name1');
insert INTO c2 VALUES (2,'name2');
insert INTO c2 VALUES (4,'name3');

create vclass v1 as 
                   select c1.id_s,c2.name FROM c1,c2 where c1.id=c2.id;

SELECT * FROM v1 order by 1;

select v1 from v1 order by 1;



drop class c1,c2;
drop vclass v1;
