
drop table if exists t;

create table t (i int, b1 BIT VARYING(100), b2 BIT VARYING(100));

insert into t(i, b1, b2) values (1, b'10100010', b'101000100011');
insert into t(i, b1, b2) values (2, b'101000100011', b'10100010');
insert into t(i, b1, b2) values (3, b'10100000', b'1010000010110000');
insert into t(i, b1, b2) values (4, b'1010000010110000', b'10100000');
insert into t(i, b1, b2) values (5, b'10100000', b'10100000101100001000');
insert into t(i, b1, b2) values (6, b'10100000101100001000', b'10100000');
insert into t(i, b1, b2) values (7, b'1010000000000000', b'101000000000000010110000');
insert into t(i, b1, b2) values (8, b'101000000000000010110000', b'1010000000000000');
insert into t(i, b1, b2) values (9, b'101000000000', b'10100000000010110000');
insert into t(i, b1, b2) values (10,b'10100000000010110000', b'101000000000');
insert into t(i, b1, b2) values (11,b'10100000', b'10110000');
insert into t(i, b1, b2) values (12,b'10110000', b'10100000');



alter table t add prefix_asc BIT VARYING (100);
alter table t add prefix_desc BIT VARYING (100);

update t set prefix_asc = INDEX_PREFIX (b1, b2, 'A') where b1 < b2;
update t set prefix_desc = INDEX_PREFIX (b1, b2, 'D') where b1 > b2;

update t set prefix_asc = INDEX_PREFIX (b2, b1, 'A') where b2 < b1;
update t set prefix_desc = INDEX_PREFIX (b2, b1, 'D') where b2 > b1;



select 'NOK - ASC', i, b1, b2, prefix_asc from t where b1 < b2 and not (b1 < prefix_asc and prefix_asc <= b2) order by i;

select 'NOK - DESC', i, b1, b2, prefix_desc from t where b1 > b2 and not (b1 > prefix_desc and prefix_desc >= b2) order by i;

select 'NOK - ASC', i, b2, b1, prefix_asc from t where b2 < b1 and not (b2 < prefix_asc and prefix_asc <= b1);

select 'NOK - DESC', i, b2, b1, prefix_desc from t where b2 > b1 and not (b2 > prefix_desc and prefix_desc >= b1);


alter table t modify b1 BIT(100);
alter table t modify b2 BIT(100);

update t set prefix_asc = INDEX_PREFIX (b1, b2, 'A') where b1 < b2;
update t set prefix_desc = INDEX_PREFIX (b1, b2, 'D') where b1 > b2;

update t set prefix_asc = INDEX_PREFIX (b2, b1, 'A') where b2 < b1;
update t set prefix_desc = INDEX_PREFIX (b2, b1, 'D') where b2 > b1;



select 'NOK - ASC', i, b1, b2, prefix_asc from t where b1 < b2 and not (b1 < prefix_asc and prefix_asc <= b2) order by i;

select 'NOK - DESC', i, b1, b2, prefix_desc from t where b1 > b2 and not (b1 > prefix_desc and prefix_desc >= b2) order by i;

select 'NOK - ASC', i, b2, b1, prefix_asc from t where b2 < b1 and not (b2 < prefix_asc and prefix_asc <= b1);

select 'NOK - DESC', i, b2, b1, prefix_desc from t where b2 > b1 and not (b2 > prefix_desc and prefix_desc >= b1);

drop table t;