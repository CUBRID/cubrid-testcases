--Insert into class with collection by subquery
create class t1(c1 set of int, c2 set of varchar(10),
                 c3 multiset char(10), c4 list of date);
                 
insert into t1 values({101,102},{'xxx','yyyy','xxx'},
                       {'aaaa','bbb','aaa','bbb'},
                       {date'05/18/2008', date'05/19/2008', date'05/08/1998'});


insert into t1 values({201,202},{'xxx','yyyy','xxx'},
                       {'aaaa','bbb','aaa','bbb'},
                       {date'05/18/2008', date'05/19/2008', date'05/08/1998'});
                       
insert into t1 values({301,202},{'xxx','yyyy','xxx'},
                       {'aaaa','bbb','aaa','bbb'},
                       {date'05/18/2008', date'05/19/2008', date'05/08/1998'});
insert into t1 (c1) values(select c1 from t1 where c1 = {101,102});

select * from t1 order by 1,2,3;

drop class t1;                                             
