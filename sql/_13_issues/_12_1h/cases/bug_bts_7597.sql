--TEST: By Design. [ENUM TYPE] Invalid value can be inserted into a table which has a foreign key constraint on the enum type column.


create table t1(a enum('a', 'b', 'c') primary key);
insert into t1 values(1), (2), (3);
create table t2(a enum('d', 'e', 'f', 'g') primary key, constraint fk_a foreign key(a) references t1(a));

insert into t2 values('d'), ('e'), ('f');

select * from t1 order by 1;
select * from t2 order by 1;


drop table t2, t1;
