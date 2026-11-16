/**
 *  This test case verifies CBRD-28007: MAX on an ascending index and MIN on a descending index return the right
 *  value when a data filter rejects the keys at the start of the scan
 *
 *  An index scan that only looks for MIN or MAX reads forward to the first row that passes its filter, then turns
 *  back and takes the first row from the other end. When it read the OIDs again from the other end, it reset the
 *  OID number to the first one but left the OID pointer at the slot where the forward scan had found its row. If
 *  the filter had rejected the keys ahead of that row, the slot was not the first one and the backward scan took
 *  another row - MAX came back smaller and MIN larger. Each case compares the index scan with USING INDEX NONE.
 *
 *  Coverage:
 *    Case 1:  MAX on an ascending index when the filter rejects the first key
 *    Case 2:  MIN on a descending index when the filter rejects the first key
 *    Case 3:  the first row from the other end fails the filter too - the scan goes on to the next one
 *    Case 4:  a table whose OIDs fill more than one buffer - the filter rejects 50 keys, then 10000 keys
 *    Case 5:  the forms that were right - another expression, another aggregate, a covering index, no key rejected
 */

drop table if exists t_asc, t_desc, t_cov, t_skip_asc, t_skip_desc, t_big, t_digit;

create table t_asc (a int, b double);
create index i_asc on t_asc (b);
-- a <= b is true for 600 and 500 and false for -700, the first key of the index
insert into t_asc values (0, 600), (1, 500), (0, -700);

create table t_desc (a int, b double);
create index i_desc on t_desc (b desc);
-- a <= b is false for 600, the first key of the descending index
insert into t_desc values (900, 600), (1, 500), (-800, -700);

evaluate 'Case 1: MAX on an ascending index when the filter rejects the first key; result = 600';
select max(b) from t_asc where b <= 1000 and a <= b using index i_asc;
select max(b) from t_asc where b <= 1000 and a <= b using index none;

evaluate 'Case 2: MIN on a descending index when the filter rejects the first key; result = -700';
select min(b) from t_desc where b >= -1000 and a <= b using index i_desc;
select min(b) from t_desc where b >= -1000 and a <= b using index none;

create table t_skip_asc (a int, b double);
create index i_skip_asc on t_skip_asc (b);
-- forward, the filter rejects -700 and -600; backward, it rejects 800 and keeps 700
insert into t_skip_asc values (0, -700), (0, -600), (1, 500), (0, 600), (0, 700), (900, 800);

create table t_skip_desc (a int, b double);
create index i_skip_desc on t_skip_desc (b desc);
-- forward, the filter rejects 800 and 700; backward, it rejects -800 and keeps -700
insert into t_skip_desc values (0, -800), (-900, -700), (-900, -600), (1, 500), (900, 700), (900, 800);

evaluate 'Case 3: the first row from the other end fails the filter too - the scan goes on to the next one; result = 700, -700';
select max(b) from t_skip_asc where b <= 1000 and a <= b using index i_skip_asc;
select max(b) from t_skip_asc where b <= 1000 and a <= b using index none;
select min(b) from t_skip_desc where b >= -1000 and a <= b using index i_skip_desc;
select min(b) from t_skip_desc where b >= -1000 and a <= b using index none;

-- b runs from 1 to 20000; lo_50 and lo_10k make a <= b reject the 50 and the 10000 smallest keys, hi_50 and hi_10k the largest
create table t_digit (n int);
insert into t_digit values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
create table t_big (b double, lo_50 int, lo_10k int, hi_50 int, hi_10k int);
insert into t_big
  select n, case when n <= 50 then 99999 else 0 end, case when n <= 10000 then 99999 else 0 end,
         case when n > 19950 then 99999 else 0 end, case when n > 10000 then 99999 else 0 end
  from (select d1.n + d2.n * 10 + d3.n * 100 + d4.n * 1000 + d5.n * 10000 + 1 as n
        from t_digit d1, t_digit d2, t_digit d3, t_digit d4, t_digit d5) x
  where x.n <= 20000;
create index i_big_asc on t_big (b);
create index i_big_desc on t_big (b desc);

evaluate 'Case 4: a table whose OIDs fill more than one buffer - the filter rejects 50 keys, then 10000 keys; result = 20000, 1';
select max(b) from t_big where b <= 1e9 and lo_50 <= b using index i_big_asc;
select max(b) from t_big where b <= 1e9 and lo_50 <= b using index none;
select max(b) from t_big where b <= 1e9 and lo_10k <= b using index i_big_asc;
select max(b) from t_big where b <= 1e9 and lo_10k <= b using index none;
select min(b) from t_big where b >= -1 and hi_50 <= b using index i_big_desc;
select min(b) from t_big where b >= -1 and hi_50 <= b using index none;
select min(b) from t_big where b >= -1 and hi_10k <= b using index i_big_desc;
select min(b) from t_big where b >= -1 and hi_10k <= b using index none;

create table t_cov (a int, b double);
create index i_cov on t_cov (b, a);
insert into t_cov values (0, 600), (1, 500), (0, -700);

-- MAX(b + 0) does not scan for MAX alone, COUNT(*) reads every row, and i_cov holds both columns of the filter
evaluate 'Case 5: the forms that were right - another expression, another aggregate, a covering index, no key rejected';
select max(b + 0) from t_asc where b <= 1000 and a <= b using index i_asc;
select max(b), count(*) from t_asc where b <= 1000 and a <= b using index i_asc;
select max(b) from t_cov where b <= 1000 and a <= b using index i_cov;
select max(b) from t_asc where b <= 1000 and a >= 0 using index i_asc;
select min(b) from t_desc where b >= -1000 and a <= 1000 using index i_desc;

drop table t_asc, t_desc, t_cov, t_skip_asc, t_skip_desc, t_big, t_digit;
