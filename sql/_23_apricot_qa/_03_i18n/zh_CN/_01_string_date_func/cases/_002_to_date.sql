--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = zh_CN';
-- date
select 'to_date( , DAY )';
--test
SELECT TO_DATE('2011年5月1日 星期日', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-01 星期日', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-02 星期一', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-03 星期二', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-04 星期三', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-05 星期四', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-06 星期五', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-07 星期六', 'yyyy-MM-DD DAY');

select 'to_date( ,  day )';
--test
SELECT TO_DATE('2011年5月1日 星期日', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-01 星期日', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-02 星期一', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-03 星期二', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-04 星期三', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-05 星期四', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-06 星期五', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-07 星期六', 'yyyy-MM-DD day');

select 'to_date( , DY )';
--test
SELECT TO_DATE('2011年5月1日 星期日', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-01 周日', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-02 周一', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-03 周二', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-04 周三', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-05 周四', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-06 周五', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-07 周六', 'yyyy-MM-DD DY');

select 'to_date( ,  dy )';
--test
SELECT TO_DATE('2011年5月1日 星期日', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-01 周日', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-02 周一', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-03 周二', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-04 周三', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-05 周四', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-06 周五', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-07 周六', 'yyyy-MM-DD dy');

-- month
select 'to_date( ,  MONTH)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 二月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 三月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 四月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 五月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 六月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 七月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 八月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 九月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 十月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 十一月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 十二月', 'yyyy-dd MONTH');

select 'to_date( ,  month)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 一月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 二月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 三月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 四月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 五月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 六月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 七月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 八月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 九月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 十月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 十一月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 十二月', 'yyyy-dd month');


select 'to_date( ,  MON)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 1月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 2月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 3月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 4月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 5月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 6月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 7月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 8月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 9月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 10月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 11月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 12月', 'yyyy-dd MON');

select 'to_date( ,  mon)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 1月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 2月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 3月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 4月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 5月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 6月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 7月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 8月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 9月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 10月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 11月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 12月', 'yyyy-dd mon');

select 'to_date( ,  Month)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 一月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 二月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 三月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 四月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 五月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 六月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 七月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 八月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 九月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 十月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 十一月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 十二月', 'yyyy-dd Month');

select 'to_date( ,  Mon)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 1月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 2月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 3月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 4月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 5月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 6月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 7月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 8月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 9月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 10月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 11月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 12月', 'yyyy-dd Mon');

--test
SELECT TO_DATE('2010-01 测试 十一月', 'yyyy-dd "测试" Mon');
--test
SELECT TO_DATE('2010-01 测试 十一月', 'yyyy-dd "测试" Mon');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

