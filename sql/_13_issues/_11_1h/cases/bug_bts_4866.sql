create table coo(
        col1 numeric(6, 3),
        col2 numeric(6, 3),
        col3 numeric(6, 3)
);


insert into coo
 values(123.345, 234.345, 345.456);


alter table coo change col1 col1 numeric(8, 5);
select col1 from coo;

alter table coo change col2 col2 numeric(7, 5);
select col2 from coo;

alter table coo change col3 col3 numeric(4, 2);
select col3 from coo;


drop table coo;



