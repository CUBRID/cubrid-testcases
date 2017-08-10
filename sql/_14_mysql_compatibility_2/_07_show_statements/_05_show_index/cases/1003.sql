-- SHOW INDEX  -- with class hierarchy

create class c1 (i integer);

create class c2 (i integer);

create class d1 under c1, c2 (id1 integer, sd1 varchar(10)) inherit i of c1 as ic1;

create class d2 under c1, c2 (id2 integer, sd2 char(10)) inherit i of c2 as ic2;
		  
insert into c1 values (1),(2);

insert into c2 values (10),(20);

insert into d1(id1,sd1,ic1,i) values (11,'abcdefg',1,100);
insert into d1(id1,sd1,ic1,i) values (12,'12',2,101);
insert into d1(id1,sd1,ic1,i) values (12,'abc',2,102);
insert into d1(id1,sd1,ic1,i) values (13,'',4,103);

insert into d2(id2,sd2,ic2,i) values (11,'abcdefg',11,-1);
insert into d2(id2,sd2,ic2,i) values (12,'12',22,-1);
insert into d2(id2,sd2,ic2,i) values (12,'abc',23,-1);
insert into d2(id2,sd2,ic2,i) values (13,'',44,-1);


create index i_c1_i on c1(i);

create unique index i_c2_i on c2(i);

create unique index i_d1_id1_sd1 on d1(id1,sd1);

create index i_d2_sd2_id2 on d2(sd2,id2);


update statistics on all classes;
show index from c1;

show index from c2;

show index from d1;

show index from d2;
		  
drop class d1;
drop class d2;
drop class c1;
drop class c2;







