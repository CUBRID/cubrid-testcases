--non-unique index related change


create table coo(col1 float not null, col2 bit varying(30), col3 varchar, index idx(col1 asc, col2 desc));

insert into coo values(11.1111, B'11111', 'aaa');
insert into coo values(55.5555, B'010111', 'fff');
insert into coo values(33.3333, B'10101', 'vvvvvv');


alter table coo change col1 col11 double not null;

alter table coo change col2 col2 bit(30);

show columns in coo;



select * from coo order by 1;


drop table coo;
