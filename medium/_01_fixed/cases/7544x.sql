autocommit off;
create class test_ldb_class(other string);
create view test_view (
	region string SHARED 'my string',
	other string) as
	select na, other from test_ldb_class;
select region, test_view.other from test_view;
select * from test_view;
select region, cp.other from test_view cp;
insert into test_view(other) values('abc');
insert into test_view(other) values('def');
select region, test_view.other from test_view;
select * from test_view;
select region, cp.other from test_view cp;

rollback;
