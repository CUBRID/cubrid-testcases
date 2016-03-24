autocommit off;
create class zz (i int, s string);
insert into zz values(1, 'yes');
select * from zz where {null} seteq {null} or {null} setneq {null};
select * from zz where {null} seteq (select {null} from class db_user)
		    or {null} setneq (select {null} from class db_user)
rollback;
