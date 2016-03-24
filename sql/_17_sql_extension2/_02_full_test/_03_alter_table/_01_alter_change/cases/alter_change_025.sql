--default related change


create table coo(col1 short default 10, col2 varchar(20) default 'aaa', col3 multiset default {1,1,2,2,3}, col4 date, col5 blob);

insert into coo(col4) values(date'2010-11-22');
insert into coo values(22, 'bbb', {2,2,5,6,8}, date'1888-10-25', bit_to_blob(B'10111'));

select col1, col2, col3, col4, blob_to_bit(col5) from coo order by 1;


--default -> none
alter table coo change col1 col1 short first;
insert into coo(col4) values('2000-1-1');
select col1, col2, col3, col4, blob_to_bit(col5) from coo order by 1;

--default -> default, no type change
alter table coo change col2 col2 varchar(20) default 'ccc' first;
insert into coo(col1, col4) values(50, '1999-9-19');
select col1, col2, col3, col4, blob_to_bit(col5) from coo order by 1;

--default -> default, with type change
alter table coo change col3 col3 set default {8, 3, 7};
insert into coo(col1, col4) values(88, date'10/10/10');
select col1, col2, col3, col4, blob_to_bit(col5) from coo order by 1;

--none -> default
alter table coo change col4 col4 date default date'12/12/12';
insert into coo(col1) values(99);
select col1, col2, col3, col4, blob_to_bit(col5) from coo order by 1;

--[er]
alter table coo change col5 col5 blob default bit_to_blob(B'1010111');

select col1, col2, col3, col4, blob_to_bit(col5) from coo order by 1;

delete from coo;
drop table coo; 
