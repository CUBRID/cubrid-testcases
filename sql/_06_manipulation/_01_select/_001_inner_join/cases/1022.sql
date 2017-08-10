--test multiple rows select using like keyword in where clause
create class aa ( a char(4), b varchar(4));
insert into aa values ('aaaa','aaaa');
insert into aa values ('aaaa',null);
insert into aa values (null,'aaaa');
insert into aa values ('aa','aa');
select * from aa where a like 'aaaa%' or b like 'aaaa%' order by 1,2;


drop class aa;
