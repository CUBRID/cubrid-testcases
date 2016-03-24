autocommit off;
create class m (mst multiset);
insert into m values ({3,3,4});
select * from m where mst <> {null, null, null};
rollback work;
rollback;
