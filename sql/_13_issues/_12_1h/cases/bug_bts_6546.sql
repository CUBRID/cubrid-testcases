create table derived_table(id int, name char(5),description varchar(100));
insert into derived_table values(1,'rocky','Astronaut in China!');
insert into derived_table values(2,'jame','teacher in China!');
insert into derived_table values(3,'jason','actor in China!');
insert into derived_table values(4,'manuo','bmw in China!');

--test old feature
select * from (select id,name,description from derived_table) derived_alias;
select * from (select id,name,description from (select * from derived_table where id >1 order by id) subquery_table where id>3) derived_alias where id=4;
select * from (select 1) a;
--this sql will return an error as missing 'from'
select 1 (select * from (select 2) b);
select 1 from (select * from (select 2) b) c;

--test new feature, support derived table without alias name
select 1 from (select 2);
select * from (select id,name,description from (select * from derived_table where id >1 order by id) where id>2) where id=4;

select NULL from (select 1);
select * from (select NULL as a) where a is not NULL ;
select * from (select 1 as a, 3 as b) where a !=1;
select * from (select 1 as a, 3 as b) where a !=2;
select * from (select id,name,description from (select * from derived_table where id >1 order by id) where id>2) where id>=3 order by id desc;

delete from derived_table;
drop derived_table;





