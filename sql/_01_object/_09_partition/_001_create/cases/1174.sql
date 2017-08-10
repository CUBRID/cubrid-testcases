-- [er]create hash partition table on a int field that casted to double with size 4 

create class aa (a int) partition by hash(cast(a as double)) partitions 4;

drop class hash_test;
