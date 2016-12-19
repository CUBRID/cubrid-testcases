drop table if exists test_xasl;
drop table if exists test_xasl_addition_tb;

create class test_xasl(
code char(2) unique,
name char(8)
);

create class test_xasl_addition_tb(
code char(7) unique,
name char(8),
t_xasl set_of test_xasl
);

insert into test_xasl_addition_tb
values('0000001', 't_xasl1',
{(insert into test_xasl values('01','tl_xasl1')),
(insert into test_xasl values('02','tl_xasl2')),
(insert into test_xasl values('03','tl_xasl3'))}
);

insert into test_xasl_addition_tb
values('0000002', 't_xasl2',
{(insert into test_xasl values('01','tl_xasl1')),
(insert into test_xasl values('02','tl_xasl2')),
(insert into test_xasl values('03','tl_xasl3'))}
);

drop table if exists test_xasl;
drop table if exists test_xasl_addition_tb;

