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

create index pref_len on tbl(text(3));

select *
	from tbl
	where text='ABABC' order by 1;

select *
	from tbl
	where text in ('ABABC','ACABC') order by 1;

select *
	from tbl
	where text like 'ABA%' order by 1;

select *
	from tbl
	where text like 'AB%' order by 1;

select *
	from tbl
	where text like '_B_BC' order by 1;

select *
	from tbl
	where text like '%B%C' order by 1;

drop index pref_len on tbl;

drop table tbl;
