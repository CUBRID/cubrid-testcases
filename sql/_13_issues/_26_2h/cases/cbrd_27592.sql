/**
 *  This test case verifies CBRD-27592: adding a foreign key whose index is
 *  ordered against the referenced primary key checks every child key.
 *
 *  When the two orders differ, the check walks the new foreign key index from
 *  its last leaf backwards. It started each previous leaf at the key count of
 *  the leaf it had just left. A previous leaf with more keys had its top keys
 *  skipped, so an orphan there was accepted, and one with fewer keys was read
 *  past its end, so valid data failed with a page error (a debug server
 *  aborted). The fix starts each leaf at its own key count.
 *
 *  Every case adds the key against the DESC primary key and then against the
 *  same values under an ASC primary key, whose forward check was always right.
 *  Both must fail with the orphan error, or both must create the key. The
 *  orphans of Cases 2 to 4 sit at the top, middle and bottom of the band of
 *  slots the old walk skipped. Case 5 is last because it aborts a debug server
 *  without the fix.
 *
 *  Coverage:
 *    Case 1:  valid child keys over many leaves; result = ASC twin
 *    Case 2:  orphan at the top of the skipped band; result = ASC twin
 *    Case 3:  orphan in the middle of the band; result = ASC twin
 *    Case 4:  orphan at the bottom of the band; result = ASC twin
 *    Case 5:  long keys then short keys, all valid; result = ASC twin
 */

drop table if exists t_child, t_vchild, t_parent_desc, t_parent_asc, t_vparent_desc, t_vparent_asc;

-- parent keys are the even values 2 to 60000, so an odd child value is an orphan
create table t_parent_desc (id int, primary key (id desc));
insert into t_parent_desc select rownum * 2 from db_class a, db_class b, db_class c limit 30000;
create table t_parent_asc (id int, primary key (id));
insert into t_parent_asc select id from t_parent_desc;
-- one child row per parent key, so the foreign key index spans about 30 leaves
create table t_child (pid int);
insert into t_child select id from t_parent_desc;
-- long keys first, then short keys that sort after them, so a later leaf holds more keys than the leaf before it
create table t_vparent_desc (v varchar(300), primary key (v desc));
insert into t_vparent_desc select 'a' || lpad (rownum, 250, '0') from db_class a, db_class b, db_class c limit 4000;
insert into t_vparent_desc select 'z' || lpad (rownum, 5, '0') from db_class a, db_class b limit 100;
create table t_vparent_asc (v varchar(300), primary key (v));
insert into t_vparent_asc select v from t_vparent_desc;
create table t_vchild (v varchar(300));
insert into t_vchild select v from t_vparent_desc;


evaluate 'Case 1: valid child keys over many leaves create the key; result = ASC twin';
alter table t_child add constraint fk_desc foreign key (pid) references t_parent_desc (id);
select index_name from db_index where class_name = 't_child' order by index_name;
select count(*) from t_child where pid > 0 using index fk_desc;
-- a second foreign key on the same column is refused (-272), so the twin comes after the drop
alter table t_child drop foreign key fk_desc;
alter table t_child add constraint fk_asc foreign key (pid) references t_parent_asc (id);
select index_name from db_index where class_name = 't_child' order by index_name;
alter table t_child drop foreign key fk_asc;


evaluate 'Case 2: an orphan at the top of the skipped band is rejected; result = ASC twin';
insert into t_child values (59819);
alter table t_child add constraint fk_desc foreign key (pid) references t_parent_desc (id);
alter table t_child add constraint fk_asc foreign key (pid) references t_parent_asc (id);
select index_name from db_index where class_name = 't_child' order by index_name;
delete from t_child where pid = 59819;


evaluate 'Case 3: an orphan in the middle of the skipped band is rejected; result = ASC twin';
insert into t_child values (58999);
alter table t_child add constraint fk_desc foreign key (pid) references t_parent_desc (id);
alter table t_child add constraint fk_asc foreign key (pid) references t_parent_asc (id);
select index_name from db_index where class_name = 't_child' order by index_name;
delete from t_child where pid = 58999;


evaluate 'Case 4: an orphan at the bottom of the skipped band is rejected; result = ASC twin';
insert into t_child values (58099);
alter table t_child add constraint fk_desc foreign key (pid) references t_parent_desc (id);
alter table t_child add constraint fk_asc foreign key (pid) references t_parent_asc (id);
select index_name from db_index where class_name = 't_child' order by index_name;
delete from t_child where pid = 58099;


evaluate 'Case 5: long keys then short keys, all valid, create the key; result = ASC twin';
alter table t_vchild add constraint fk_vdesc foreign key (v) references t_vparent_desc (v);
select index_name from db_index where class_name = 't_vchild' order by index_name;
select count(*) from t_vchild where v > '' using index fk_vdesc;
alter table t_vchild drop foreign key fk_vdesc;
alter table t_vchild add constraint fk_vasc foreign key (v) references t_vparent_asc (v);
select index_name from db_index where class_name = 't_vchild' order by index_name;
alter table t_vchild drop foreign key fk_vasc;

drop table t_child, t_vchild, t_parent_desc, t_parent_asc, t_vparent_desc, t_vparent_asc;
