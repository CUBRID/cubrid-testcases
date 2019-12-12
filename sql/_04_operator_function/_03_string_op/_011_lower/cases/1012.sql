--test lower function with set type
create class tb(
	col1 varchar
);

insert into tb values('VARCHAR1');
insert into tb values('VARCHAR2');

select * from tb where col1 like '%var%' order by 1;
select * from tb where lower(col1) like '%var%' order by 1;

drop class tb;
