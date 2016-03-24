create table tbl(id int, text varchar(32));

insert into tbl values(1,'AAABC');
insert into tbl values(2,'AABBC');
insert into tbl values(3,'ABABC');
insert into tbl values(4,'BABBC');
insert into tbl values(5,'AAABC');
insert into tbl values(6,'ABBBC');
insert into tbl values(7,'ACABC');
insert into tbl values(8,'CAABC');
insert into tbl values(9,'AACBC');

create table tbl2(id int,prefix varchar(3));

insert into tbl2
	select id,substring(text,1,3)
		from tbl;

create index pref_len on tbl(text(3));

select *
	from tbl
	where text='ABABC' order by 1;

select *
	from tbl as t1
		inner join tbl2 as t2 on t1.id=t2.id
	where t1.text='AAABC' order by 1;

select *
	from tbl as t1
		inner join tbl2 as t2 on t1.id=t2.id
	where t1.text in ('AAABC','CAABC') order by 1;

select *
	from tbl as t1
		inner join tbl2 as t2 on t1.id=t2.id
	where t1.text like 'A%ABC' order by 1;

select *
	from tbl as t1
		inner join tbl2 as t2 on t1.id=t2.id
	where t1.text like '_AABC' order by 1;

drop index pref_len on tbl;

drop table tbl;
drop table tbl2;
