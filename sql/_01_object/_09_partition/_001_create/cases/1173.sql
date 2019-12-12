-- create hash partition table on a int field that casted to float with size 4 

create class aa (a int) partition by hash(cast(a as float)) partitions 4;

drop class hash_test;
