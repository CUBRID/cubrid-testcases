--test multiple rows select using group by clause and groupby_num, orderby_num functions
create class aa ( a int );
insert into aa values (1);
insert into aa values (2);
insert into aa values (2);
insert into aa values (3);
insert into aa values (3);
insert into aa values (3);
insert into aa values (4);
insert into aa values (4);
insert into aa values (4);
insert into aa values (4);
insert into aa values (5);
insert into aa values (5);
insert into aa values (5);
insert into aa values (5);
insert into aa values (5);
select orderby_num(), a  from aa order by a;
select orderby_num(), a  from aa order by a for orderby_num() <= 5;
select ORDERBY_NUM(), a  from aa order by a for ORDERBY_num() = 3;
select groupby_num(), a, count(*) from aa group by a order by 1;
select groupby_num(), a, count(*) from aa  group by a having groupby_num() = 3 order by 1;
select groupby_num(), orderby_num(), a, count(*) from aa  group by a order by a;
select groupby_num(), orderby_num(), a, count(*) from aa  group by a order by a for orderby_num() = 3;
select groupby_num(), orderby_num(), a, count(*) from aa  group by a having groupby_num() = 3 order by a for orderby_num() = 1;
select GROUPBY_NUM(), orderby_num(), a, count(*) from aa  group by a having groupby_num() = 3 order by a for orderby_num() = 1;
select orderby_num(), a  from aa;

drop class aa;
