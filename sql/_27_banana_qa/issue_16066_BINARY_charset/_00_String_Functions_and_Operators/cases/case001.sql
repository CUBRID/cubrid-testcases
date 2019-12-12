--+ holdcas on;
set names binary;

CREATE TABLE case_tbl( a INT);
INSERT INTO case_tbl VALUES (1);
INSERT INTO case_tbl VALUES (2);
INSERT INTO case_tbl VALUES (3);
INSERT INTO case_tbl VALUES (NULL);

--case operation with a search when clause

SELECT a,
       CASE WHEN a=1 THEN '字符.串1'
            WHEN a=2 THEN '12345가나다라마가나다라마'
            ELSE 'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2'
       END
FROM case_tbl
order by a NULLS LAST;


SELECT a,
       CASE WHEN a=1 THEN HEX('字符.串1')
            WHEN a=2 THEN cast( _utf8'12345가나다라마가나다라마' as string charset euckr)
            ELSE cast( _utf8'가나다라마가나다라마' as string charset euckr)
       END
FROM case_tbl
order by a NULLS LAST;


SELECT a,
       CASE WHEN a=1 THEN cast( _utf8'1다라마' as string charset euckr)
            WHEN a=2 THEN cast( _utf8'2라마가나다라마' as string charset euckr)
            ELSE cast( _utf8'3가나다라마가나다라마' as string charset euckr)
       END
FROM case_tbl
order by a NULLS LAST;


SELECT a,
       CASE WHEN a=1 THEN '字符.串1'
            WHEN a=2 THEN cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591)
            ELSE cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591)
       END
FROM case_tbl
order by a NULLS LAST;


SELECT a,
       CASE WHEN a=1 THEN '字符.串1'
            WHEN a=2 THEN cast( _utf8'12345가나다라마가나다라마' as string charset euckr)
            ELSE cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591)
       END
FROM case_tbl
order by a NULLS LAST;


SELECT a,
       CASE WHEN 1 THEN '字符.串1'
            WHEN 2 THEN cast( _utf8'12345가나다라마가나다라마' as string charset euckr)
            ELSE cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591)
       END
FROM case_tbl
order by a NULLS LAST;


SELECT a,
       CASE WHEN a=1 THEN '字符.串1'
            WHEN a=2 THEN cast( _utf8'12345가나다라마가나다라마' as string charset euckr)
            ELSE 1.2
       END
FROM case_tbl
order by a NULLS LAST;


drop table case_tbl;
set names iso88591;
commit;
--+ holdcas off;
