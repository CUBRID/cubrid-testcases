--test the 'like' operator with the 'exists' keyword

create class aa ( a varchar(10), b int );

insert into aa values ( 'test', 1);
select * from aa where exists ( select a from aa where a like '%test%');
select * from aa where exists ( select a from aa where a like '%test');


drop class aa;