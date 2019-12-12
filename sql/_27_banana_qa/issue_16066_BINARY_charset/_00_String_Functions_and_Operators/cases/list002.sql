--+ holdcas on;
set names utf8;

create table list_test(id int,
			col_binary char(50) collate binary,
			col_euckr varchar(2000) collate euckr_bin,
                       col_utf8 varchar(10) collate utf8_bin, 
		       col_iso varchar(10) collate iso88591_bin,
                primary key(id, col_binary))
	PARTITION BY LIST (col_binary) (
	   PARTITION p0 VALUES IN (_binary'şşşşşş',_binary'문자열문자열문자열'),    
	   PARTITION p1 VALUES IN (_binary'啊阿',_binary'你好')
	);

      insert into list_test values(1,'şşşşşş','문자열','你你你','ĞĞĞĞĞĞĞĞĞĞ');
      insert into list_test values(2,cast( _utf8'문자열문자열문자열' as string charset euckr),'문자열','你你你','ĞĞĞĞĞĞĞĞĞĞ');
      insert into list_test values(3,cast( _utf8'àé' as string charset iso88591),'문자열','你你你','ĞĞĞĞĞĞĞĞĞĞ');

delete from list_test  where col_binary   = 'şşşşşş';
select * from list_test order by 1;


drop table list_test;
set names iso88591;
commit;
--+ holdcas off;
