select insert('txs',2,1,'hi'),insert('is ',4,0,'a'),insert('txxxxt',2,4,'es');
select insert('txs',2,1,'hi'),insert('is ',4,0,'a'),insert('txxxxt',2,4,'es');

(select insert('txs',2,1,'hi'),insert('is ',4,0,'a'),insert('txxxxt',2,4,'es'),insert('txs',2,1,'hi'),insert('is ',4,0,'a'),insert('txxxxt',2,4,'es'))
union 
(select insert('txs',2,1,'hi'),insert('is ',4,0,'a'),insert('txxxxt',2,4,'es'),insert('txs',2,1,'hi'),insert('is ',4,0,'a'),insert('txxxxt',2,4,'es'));
