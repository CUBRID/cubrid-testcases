
set timezone '+9:00';

--TEST: pass no arguments
select addtime();

--TEST: pass 1 argument
select addtime('12:12:12');

--TEST: pass 3 arguments
select addtime('2010-01-04', 4, 5);

--TEST: pass null
select addtime(null);

set timezone 'Asia/Seoul';

