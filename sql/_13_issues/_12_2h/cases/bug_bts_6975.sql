create table foo (a char(10), b varchar(10));
insert into foo values ('1234567890', '1234567890');

-- should give an error (constant expressions cannot be used as function index)
create index i_foo_trans_a_b on foo (translate(a, b, null));
drop index i_foo_trans_a_b on foo;

create index i_foo_trans_a_b on foo (translate(a, null, b));
drop index i_foo_trans_a_b on foo;

create index i_foo_trans_a_b on foo (translate(null, a, b));
drop index i_foo_trans_a_b on foo;

-- should work
create index i_foo_trans_a_b on foo (translate(a, a, b));
drop index i_foo_trans_a_b on foo;


-- should return null and give no error
select translate(a, b, null) from foo;
select translate(a, null, b) from foo;
select translate(null, a, b) from foo;

drop foo;

-- should give an error (constant expressions cannot be used as function index)
create table foo (a int);
create index idx on foo(5);
drop foo;
