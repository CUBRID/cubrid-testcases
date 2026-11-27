/**
 *  This test case verifies CBRD-27845: the foreign key check of an INSERT or an UPDATE
 *  released the class representation of only the last referenced class
 *
 *  For each foreign key with a non-NULL key, locator_check_foreign_key fixed the class
 *  representation of the referenced class and, when that class is partitioned, loaded a
 *  pruning context, but it released only the last of them at its end. With two foreign
 *  keys to partitioned tables, the next key dropped the pruning context of the first key
 *  with its private allocations, and a debug server stops on that leak at the end of the
 *  request. The fix releases the representation and the pruning context of each key once
 *  pruning has found the index to search.
 *
 *  The key of a multi-column foreign key is built in a buffer of its own when the row is
 *  longer than 4096 bytes. An error that left the check, such as a partition expression
 *  that fails, did not free that buffer either, which a debug server also stops on. The
 *  fix clears the key on the error exits as well.
 *
 *  c_two has foreign keys to a hash and to a range partitioned table, and c_mix has one to
 *  a plain table and one to a hash partitioned table. Each DML statement that checks the
 *  foreign keys of a row runs on them, and a SELECT after each case shows the rows. c_wide
 *  has a multi-column foreign key to a table partitioned on 100 div a, and its rows are
 *  longer than the key buffer.
 *
 *  Coverage:
 *    Case 1:  INSERT of one row with both keys set succeeds
 *    Case 2:  INSERT of several rows with a VALUES list succeeds
 *    Case 3:  INSERT SELECT succeeds
 *    Case 4:  UPDATE of a column outside the keys succeeds
 *    Case 5:  UPDATE of a key column to a value of its parent succeeds
 *    Case 6:  a key missing from the range partitioned parent fails with -922
 *    Case 7:  a key outside every range partition fails with -922
 *    Case 8:  a key missing from the hash partitioned parent fails with -922
 *    Case 9:  UPDATE of a key column to a missing value fails and keeps the row
 *    Case 10: NULL keys skip the check
 *    Case 11: a plain parent and a partitioned parent - valid and missing keys
 *    Case 12: MERGE updates one row and inserts another
 *    Case 13: INSERT ON DUPLICATE KEY UPDATE updates the existing row
 *    Case 14: a row longer than the key buffer with a valid multi-column key succeeds
 *    Case 15: a row longer than the key buffer whose key fails the partition expression fails with -539
 */

drop table if exists c_two;
drop table if exists c_mix;
drop table if exists c_wide;
drop table if exists p_hash, p_range, p_plain, p_div, t_hex;

create table p_hash (id int primary key) partition by hash (id) partitions 3;
create table p_range (id int primary key) partition by range (id) (partition r_low values less than (100), partition r_high values less than (200));
create table p_plain (id int primary key);
insert into p_hash values (1), (2), (3), (4), (5), (6);
insert into p_range values (10), (20), (150), (190);
insert into p_plain values (1), (2), (3);

create table c_two (id int primary key, a int, b int, v varchar(10), constraint fk_two_hash foreign key (a) references p_hash (id), constraint fk_two_range foreign key (b) references p_range (id));
create table c_mix (id int primary key, a int, b int, constraint fk_mix_plain foreign key (a) references p_plain (id), constraint fk_mix_hash foreign key (b) references p_hash (id));

-- 48 SHA-512 hex digests joined: 6,144 characters that do not compress, so that a row of c_wide is longer than the 4,096-byte buffer (DBVAL_BUFSIZE) in which the key of a multi-column foreign key is built
set system parameters 'group_concat_max_len=8192';
create table t_hex (h varchar(128));
insert into t_hex select sha2(cast(rownum as varchar), 512) from db_class a, db_class b limit 48;
-- p_div partitions on 100 div a: a key with a = 0 fails the partition expression while the foreign key check prunes p_div
create table p_div (a int, b varchar(10), primary key (a, b)) partition by range (100 div a) (partition d_low values less than (10), partition d_high values less than maxvalue);
insert into p_div values (1, 'k'), (50, 'k');
create table c_wide (id int primary key, a int, b varchar(10), pad varchar(8000), constraint fk_wide_div foreign key (a, b) references p_div (a, b));


evaluate 'Case 1: INSERT of one row with both keys set succeeds';
insert into c_two values (1, 1, 10, 'one');
select id, a, b, v from c_two order by id;

evaluate 'Case 2: INSERT of several rows with a VALUES list succeeds';
insert into c_two values (2, 2, 20, 'two'), (3, 3, 150, 'three');
select id, a, b, v from c_two order by id;

evaluate 'Case 3: INSERT SELECT succeeds';
insert into c_two select id + 10, id, 190, 'sel' from p_hash where id in (4, 5);
select id, a, b, v from c_two order by id;

-- every UPDATE of a row runs the foreign key check of that row, also when no key column changes
evaluate 'Case 4: UPDATE of a column outside the keys succeeds';
update c_two set v = 'upd' where id <= 3;
select id, a, b, v from c_two order by id;

evaluate 'Case 5: UPDATE of a key column to a value of its parent succeeds';
update c_two set b = 20 where id = 1;
select id, a, b, v from c_two order by id;

evaluate 'Case 6: a key missing from the range partitioned parent fails; result = -922';
-- 50 falls in partition r_low, which has no row 50
insert into c_two values (6, 6, 50, 'bad');
select count(*) from c_two where id = 6;

evaluate 'Case 7: a key outside every range partition fails; result = -922';
insert into c_two values (7, 1, 500, 'bad');
select count(*) from c_two where id = 7;

evaluate 'Case 8: a key missing from the hash partitioned parent fails; result = -922';
insert into c_two values (8, 9, 10, 'bad');
select count(*) from c_two where id = 8;

evaluate 'Case 9: UPDATE of a key column to a missing value fails and keeps the row; result = -922';
update c_two set a = 99 where id = 2;
select id, a, b, v from c_two where id = 2;

evaluate 'Case 10: NULL keys skip the check';
insert into c_two values (10, null, 10, 'n_hash'), (11, 1, null, 'n_range'), (12, null, null, 'n_both');
select id, a, b, v from c_two order by id;

evaluate 'Case 11: a plain parent and a partitioned parent - valid and missing keys; result = -922 for the missing keys';
insert into c_mix values (1, 1, 1);
insert into c_mix values (2, 1, 9);
insert into c_mix values (3, 9, 1);
select id, a, b from c_mix order by id;

evaluate 'Case 12: MERGE updates one row and inserts another';
merge into c_two t using (select 2 id, 3 a, 190 b from db_root union all select 20, 6, 10 from db_root) s on (t.id = s.id)
when matched then update set t.a = s.a, t.b = s.b
when not matched then insert values (s.id, s.a, s.b, 'mrg');
select id, a, b, v from c_two order by id;

-- the update of the existing row runs the foreign key check of that row
evaluate 'Case 13: INSERT ON DUPLICATE KEY UPDATE updates the existing row';
insert into c_two values (1, 4, 150, 'dup') on duplicate key update v = 'odku';
select id, a, b, v from c_two order by id;

evaluate 'Case 14: a row longer than the key buffer with a valid multi-column key succeeds';
insert into c_wide select 1, 1, 'k', group_concat(h order by h separator '') from t_hex;
select id, a, b, length(pad) from c_wide order by id;

evaluate 'Case 15: a row longer than the key buffer whose key fails the partition expression fails; result = -539';
-- the division by zero leaves the foreign key check after the key took a buffer of its own
insert into c_wide select 2, 0, 'k', group_concat(h order by h separator '') from t_hex;
select id, a, b, length(pad) from c_wide order by id;

drop table c_two;
drop table c_mix;
drop table c_wide;
drop table p_hash, p_range, p_plain, p_div, t_hex;
set system parameters 'group_concat_max_len=default';
