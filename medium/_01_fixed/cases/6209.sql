autocommit off;

CREATE CLASS bar(cnt integer);
CREATE CLASS test_me(
 number integer,
 a	sequence(bar),
 b	sequence(bar),
 c      sequence(int),
 d      sequence(int));
insert into bar values(1) into a1;
insert into bar values(2) into a2;
insert into bar values(1001) into b1;
insert into bar values(1002) into b2;
insert into test_me values(1, {a1,a2}, {b1, b2}, {1,2,3}, {2,3,4});
select a-b, c-d from test_me;  -- pr6208
select a*b, c*d from test_me;  -- pr6209
select a+b, c+d from test_me;
rollback;
