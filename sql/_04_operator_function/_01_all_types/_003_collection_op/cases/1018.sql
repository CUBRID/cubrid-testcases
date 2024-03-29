--test operators seteq, subset, superset, superseteq with set(multiset,list) of bit
create class tb ( a set(bit(8)), b multiset(bit(8)) , c list(bit(8)));
insert into tb values ( {},{},{});
insert into tb values ( null,null,null);

insert into tb values ({b'0001'},{b'0001'},{b'0001'});
insert into tb values ( {b'0010'},{b'0010'},{b'1000'});
insert into tb values ( {b'0000'},{b'0100'},{b'0100'});

select a, b from tb where a seteq b order by 1,2;
select a, b from tb where a superset b order by 1,2;
select a, b from tb where a subset b order by 1,2;
select a, b from tb where a setneq b order by 1,2;
select a, b from tb where a subseteq b order by 1,2;
select a, b from tb where a superseteq b order by 1,2;
select a, c from tb where a seteq c order by 1,2;
select a, c from tb where a superset c order by 1,2;
select a, c from tb where a subset c order by 1,2;
select a, c from tb where a setneq c order by 1,2;
select a, c from tb where a subseteq c order by 1,2;
select a, c from tb where a superseteq c order by 1,2;
select b, c from tb where b seteq c order by 1,2;
select b, c from tb where b superset c order by 1,2;
select b, c from tb where b subset c order by 1,2;
select b, c from tb where b setneq c order by 1,2;
select b, c from tb where b subseteq c order by 1,2;
select b, c from tb where b superseteq c order by 1,2;
select a, a from tb where a seteq a order by 1,2;
select b, b from tb where b seteq b order by 1,2;
select c, c from tb where c seteq c order by 1,2;
select a, a from tb where a setneq a order by 1,2;
select b, b from tb where b setneq b order by 1,2;
select c, c from tb where c setneq c order by 1,2;

drop class tb;
