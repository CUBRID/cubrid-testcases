-- SHOW INDEX  -- with prefix length key
-- order : asc and descending
-- one column with not null
create table t1( i1 integer , i2 integer not null, i3 integer unique, s1 varchar(10), s2 varchar(10), s3 varchar(10) unique);
		  
create index i_t1_i1 on t1(i1 desc);

create index i_t1_s1 on t1(s1(7));

create index i_t1_i1_s1 on t1(i1,s1);

create unique index i_t1_i2_s2 on t1(i2,s2);

insert into t1 values (1,1,1,'abc','abc','abc');
insert into t1 values (2,2,2,'zabc','zabc','zabc');
insert into t1 values (2,3,3,'+abc','+abc','+abc');
insert into t1 values (4,4,4,'123','123','123');
insert into t1 values (5,5,5,'ocp','ocp','ocp');
insert into t1 values (6,6,6,'qwert','qwert','qwert');
insert into t1 values (6,6,7,'()abc','()abc','()abc+');
insert into t1 values (8,8,8,'{}abc','{}abc','{}abc+');
insert into t1 values (9,9,9,'[abc]','[abc]','[abc+]');
insert into t1 values (10,10,10,'abc','abc','123abcx');
insert into t1 values (11,11,11,'+_+','+_+','+_+');
insert into t1 values (11,12,12,'123qwe','123qwe','123qwe');
insert into t1 values (13,13,13,'!@#$%^&*','!@#$%^&*','!@#$%^&*');
insert into t1 values (14,14,14,'abc','abc','{abc]');
insert into t1 values (15,15,15,'zxcvbnm','zxcvbnm','zxcvbnm');
insert into t1 values (15,15,16,'zxcvbnm','zxc','vbnm');
insert into t1 values (17,15,17,'zxcvbnm','zm','09nm');
insert into t1 values (18,18,18,'zxcvbnm','zxcvbnm','v');
insert into t1 values (15,19,19,'zxcvbnm','zxcvbnm','zm');
insert into t1 values (15,20,20,'zxcvbnm','zxcvbnm','m22');



show index in t1;

-- syntax variants: 
-- INDEXES
show indexes in t1;

-- KEYS
show keys in t1;
		  
drop table t1;








