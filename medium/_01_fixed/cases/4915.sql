autocommit off;
create class test_class( attr1 int, attr2 int, attr3 int not null );
create vclass test_vclass
as select attr1, attr2 from test_class where attr3 < 1000;
insert into test_class values( 100, 1, 100 );
insert into test_class values( 200, 2, 200 );
insert into test_class values( 300, 3, 300 );
insert into test_class values( NULL, NULL, 400 );
insert into test_class values( 500, 5, 500 );
insert into test_class values( 600, 6, 600 );
insert into test_class values( 700, NULL, 700 );
insert into test_class values( NULL, 8, 800 );
insert into test_class values( 900, NULL, 900 );
insert into test_class values( 1000, 10, 1000 );
insert into test_class values( 1100, NULL, 1100 );
insert into test_class values( NULL, 12, 1200 );
select a.attr1, b.attr1, a.attr2, b.attr2
from test_class a, test_vclass b
where (((a.attr1 = b.attr1) or ((a.attr1 is null) and b.attr1 is null)))
and  (((a.attr2 = b.attr2) or ((a.attr2 is null) and b.attr2 is null)));
rollback;
