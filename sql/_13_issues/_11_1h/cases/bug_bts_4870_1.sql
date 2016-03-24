create table coo(
        col1 char(30),
        col2 char(30)
);

insert into coo values('-8237923123', '123242347439281078412122');


alter table coo change col1 col1 bigint;
select col1 from coo;

alter table coo change col2 col2 bigint;
select col2 from coo;

drop table coo;


