autocommit off;
create class B (bn int);
create class A (ab B, an int);
insert into B values (10) to :b0;	--   1
insert into B values (20) to :b1;	--   2
insert into B select * from B;		--   4
insert into B select * from B;		--   8
insert into B select * from B;		--  16
insert into B select * from B;		--  32
insert into B select * from B;		--  64
insert into B select * from B;		-- 128
insert into A values (:b0, 100) to :a0;
create class dummy
	method class set_cost(string, string)
		function qo_set_cost;
call set_cost('nl-join', '0') on class dummy;
update statistics on A, B;
--set optimization: level 257;
select an, ab.bn from A;
rollback;
