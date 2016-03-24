drop table if exists t1;
create class t1 class attribute( i integer primary key) (i integer);
ALTER TABLE t1 MODIFY CLASS ATTRIBUTE i INTEGER DEFAULT 1;
drop table if exists t1;
