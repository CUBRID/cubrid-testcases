CREATE CLASS [test_table] REUSE_OID, COLLATE utf8_bin;
 
ALTER CLASS [test_table] ADD ATTRIBUTE
[sseq] numeric(8,0) NOT NULL,
[ppseq] numeric(8,0) NOT NULL,
[tppseq] numeric(8,0) NOT NULL,
[cyn] numeric(1,0) DEFAULT 0,
[sid] character(3) COLLATE utf8_bin,
[tseq] numeric(8,0),
[gseq] numeric(8,0) NOT NULL;

create view test1 ( cyn string ) as select group_concat(decode([test_table].[cyn], 1, '000', [test_table].[sid]) separator ',' ) from [test_table] [test_table];

select * from test1;
drop test1;
drop class test_table;
