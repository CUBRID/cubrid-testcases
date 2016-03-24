--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = zh_CN';
-- to_datetime
select 'TO_DATETIME( , DAY   )';
SELECT TO_DATETIME('2011年5月1日 星期日 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-01 星期日 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-02 星期一 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-03 星期二 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-04 星期三 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-05 星期四 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-06 星期五 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-07 星期六 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');

select 'TO_DATETIME( ,  day )';
SELECT TO_DATETIME('2011年5月1日 星期日', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-01 星期日', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-02 星期一', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-03 星期二', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-04 星期三', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-05 星期四', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-06 星期五', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-07 星期六', 'yyyy-MM-DD day');

select 'TO_DATETIME( , DY )';
SELECT TO_DATETIME('2011年5月1日 星期日', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-01 周一', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-01 周日', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-02 周一', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-03 周二', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-04 周三', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-05 周四', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-06 周五', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-07 周六', 'yyyy-MM-DD DY');

select 'TO_DATETIME( ,  dy )';
SELECT TO_DATETIME('2011年5月1日 星期日', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-01 周日', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-02 周一', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-03 周二', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-04 周三', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-05 周四', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-06 周五', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-07 周六', 'yyyy-MM-DD dy');

-- month
select 'TO_DATETIME( ,  MONTH)';
SELECT TO_DATETIME('2010年1月1日', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 一月', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 二月', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 三月', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 四月', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 五月', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 六月', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 七月', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 八月', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 九月', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 十月', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 十一月', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 十二月', 'yyyy-dd MONTH');

select 'TO_DATETIME( ,  month)';
SELECT TO_DATETIME('2010年1月1日', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 一月', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 二月', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 三月', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 四月', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 五月', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 六月', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 七月', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 八月', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 九月', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 十月', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 十一月', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 十二月', 'yyyy-dd month');


select 'TO_DATETIME( ,  MON)';
SELECT TO_DATETIME('2010年1月1日', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 1月', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 2月', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 3月', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 4月', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 5月', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 6月', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 7月', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 8月', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 9月', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 10月', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 11月', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 12月', 'yyyy-dd MON');

select 'TO_DATETIME( ,  mon)';
SELECT TO_DATETIME('2010年1月1日', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 1月', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 2月', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 3月', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 4月', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 5月', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 6月', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 7月', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 8月', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 9月', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 10月', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 11月', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 12月', 'yyyy-dd mon');

select 'TO_DATETIME( ,  Month)';
SELECT TO_DATETIME('2010年1月1日', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 一月', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 二月', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 三月', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 四月', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 五月', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 六月', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 七月', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 八月', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 九月', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 十月', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 十一月', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 十二月', 'yyyy-dd Month');



-- text
SELECT TO_DATETIME('2010-01 测试 十一月', 'yyyy-dd "teıt" Mon');

SELECT TO_DATETIME('2010-01 测试 十一月', 'yyyy-dd "teSt" Mon');

select 'TO_DATETIME( ,  PM)';
SELECT TO_DATETIME('2011-05-01   星期日 10:11:12 下午', 'yyyy-MM-DD DAY HH:MI:SS PM');
SELECT TO_DATETIME('2011-05-01   星期日 10:11:12 上午', 'yyyy-MM-DD DAY HH:MI:SS AM');
SELECT TO_DATETIME('2011-05-01   星期日 10:11:12 P.M.', 'yyyy-MM-DD DAY HH:MI:SS P.M.');
SELECT TO_DATETIME('2011-05-01   星期日 10:11:12 A.M.', 'yyyy-MM-DD DAY HH:MI:SS A.M.');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

