create table t1( i1 integer , 
i2 integer not null, 
i3 integer unique,
s1 varchar(10),
s2 varchar(10),
s3 varchar(10) unique);

create index i_t1_i1 on t1(i1 desc);
create index i_t1_s1 on t1(s1(7));
create index i_t1_i1_s1 on t1(i1,s1);
create unique index i_t1_i2_s2 on t1(i2,s2);

insert into t1 values (1,1,1,'abc','abc','abc');
insert into t1 values (2,2,2,'zabc','zabc','zabc');
insert into t1 values (2,3,3,'+abc','+abc','+abc');

select index_cardinality('t1','i_t1_i1_s1',0);
select index_cardinality('t1','i_t1_i1_s1',1);
select index_cardinality('t1','i_t1_i1_s1',2);
select index_cardinality('t123','i_t1_i1_s1',1);

drop table t1;

