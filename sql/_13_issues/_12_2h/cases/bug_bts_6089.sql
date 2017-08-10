drop table if exists [test_inbox_info];

;set level 515

CREATE CLASS [test_inbox_info];

ALTER CLASS [test_inbox_info] ADD ATTRIBUTE
       [test_id] integer NOT NULL,
       [usid] integer NOT NULL,
       [rtype] character(5) NOT NULL,
       [iflag] character(1),
       [mtype] character(5) NOT NULL;


ALTER CLASS [test_inbox_info] ADD ATTRIBUTE
       CONSTRAINT [pk_test_inbox_info_service_id_usid_message_type_relation_type] PRIMARY KEY([test_id], [usid], [mtype], [rtype]),
       CONSTRAINT [xpktest_inbox_info] UNIQUE([test_id], [usid], [rtype]);

INSERT INTO test_inbox_info   (test_id, usid, mtype, rtype)   VALUES(1010, 9999, 'MEPOS', 'MEFR2')   ON DUPLICATE KEY UPDATE iflag='T';

;set level 1

drop table if exists [test_inbox_info];

