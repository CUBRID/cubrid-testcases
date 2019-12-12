--test decr function with types int, smallint
create class tb(
        col0 int auto_increment primary key,
		col1 INT,
		col2 smallint
);

insert into tb (col1, col2) values(1, 11);
insert into tb (col1, col2) values(2, 22);


select decr(col1) from tb where col0=1;
select decr(col1) from tb where col0=1;

select decr(col2) from tb where col0=1;
select decr(col2) from tb where col0=1;

drop class tb;
