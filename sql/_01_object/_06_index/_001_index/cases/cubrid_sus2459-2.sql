--test case for CUBRIDSUS-2459,  index crash

CREATE CLASS foo (
        attr_a character varying(20) NOT NULL,
        attr_b character(1) DEFAULT 'N' 
        );

-- step 2
insert into foo (attr_a) values ('1');
insert into foo (attr_a) values ('2');
insert into foo (attr_a) values ('3');

-- step 3
insert into foo values ('4', 'N');
insert into foo values ('5', 'N');
insert into foo values ('6', 'N');
insert into foo values ('7', 'N');

-- step 4
create index i on foo(attr_b, attr_a);

-- checkpoint 1
select * from foo where attr_b = 'N' using index i(+) order by 1,2;
select * from foo where attr_b = 'N' using index none order by 1,2;

-- step 5, 6
update foo set attr_a='10' where attr_a='1' and attr_b='N' using index i(+);
update foo set attr_a='40' where attr_a='4' and attr_b='N' using index i(+);

-- checkpoint 2
select * from foo where attr_b = 'N' using index i(+) order by 1,2;
select * from foo where attr_b = 'N' using index none order by 1,2;

-- step 7, 8
delete from foo where attr_a='2' and attr_b='N' using index i(+);
delete from foo where attr_a='5' and attr_b='N' using index i(+);

-- checkpoint 3
select * from foo where attr_b = 'N' using index i(+) order by 1,2;
select * from foo where attr_b = 'N' using index none order by 1,2;

select * from foo order by 1,2;

drop class foo;


CREATE CLASS foo (
        attr_a character varying(20) NOT NULL,
        attr_b character(1) 
        );

-- step 2
insert into foo (attr_a) values ('1');
insert into foo (attr_a) values ('2');
insert into foo (attr_a) values ('3');

-- step 3
insert into foo values ('4', 'N');
insert into foo values ('5', 'N');
insert into foo values ('6', 'N');
insert into foo values ('7', 'N');

-- step 4
create index i on foo(attr_b, attr_a);

-- checkpoint 1
select * from foo where attr_b = 'N' using index i(+) order by 1,2;
select * from foo where attr_b = 'N' using index none order by 1,2;

-- step 5, 6
update foo set attr_a='10' where attr_a='1' and attr_b='N' using index i(+);
update foo set attr_a='40' where attr_a='4' and attr_b='N' using index i(+);

-- checkpoint 2
select * from foo where attr_b = 'N' using index i(+) order by 1,2;
select * from foo where attr_b = 'N' using index none order by 1,2;

-- step 7, 8
delete from foo where attr_a='2' and attr_b='N' using index i(+);
delete from foo where attr_a='5' and attr_b='N' using index i(+);

-- checkpoint 3
select * from foo where attr_b = 'N' using index i(+) order by 1,2;
select * from foo where attr_b = 'N' using index none order by 1,2;

select * from foo order by 1,2;

drop class foo;

