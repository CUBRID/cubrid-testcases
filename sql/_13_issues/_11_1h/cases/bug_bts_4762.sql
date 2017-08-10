create table tb (id int primary key, a int);
insert into tb values (4,4);
insert into tb values (1,1);
insert into tb values (2,2);
insert into tb values (3,3);

--result is good
select a,groupby_num()%2 from tb where a between 1 and 4 group by a desc;
--expect two records were returned.
select a,groupby_num()%2 from tb where a between 1 and 4 group by a desc having groupby_num()%2=0;

drop table tb;


