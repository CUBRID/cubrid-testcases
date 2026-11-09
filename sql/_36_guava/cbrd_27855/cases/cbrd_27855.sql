-- CBRD-27855: pt_cnf () distributed (A and B) or (C and D) into (A or C), (A or D), (B or C), (B or D).
-- The optimizer multiplied those correlated clauses as if they were independent, so a join or a
-- scan under such a condition was estimated far below its real row count, and every literal was
-- evaluated once per clause it landed in.  The factor now stays whole, and the restrictions a scan
-- or an index can use (one spec, one column) are derived from it.

drop table if exists nat, fact, pair;

create table nat (id int primary key, n_name varchar (25));
insert into nat select rownum, case when rownum <= 49 then 'FRANCE' when rownum <= 99 then 'GERMANY' else 'N' || mod (rownum, 23) end from db_class a, db_class b limit 1000;
create index i_nat_name on nat (n_name);

create table fact (id int, k int, pad varchar (100));
insert into fact select rownum, mod (rownum, 2000), 'p' from db_class a, db_class b, db_class c limit 20000;
create index i_fact_k on fact (k);

create table pair (id int primary key, a varchar (10), b varchar (10));
insert into pair select rownum, case mod (rownum, 20) when 0 then 'X' when 1 then 'Y' else 'P' || mod (rownum, 20) end, case mod (rownum / 20, 20) when 0 then 'Y' when 1 then 'X' else 'Q' || mod (rownum / 20, 20) end from db_class a, db_class b, db_class c limit 20000;
create index i_pair_a on pair (a);
create index i_pair_ab on pair (a, b);

update statistics on nat, fact, pair with fullscan;

evaluate 'Case 1: the nation pair joins fact before the other alias -- the pair is 4900 rows, not 87';
--@queryplan
select /*+ recompile */ count (*) from nat sn, nat cn, fact where sn.id = fact.id and ((sn.n_name = 'FRANCE' and cn.n_name = 'GERMANY') or (sn.n_name = 'GERMANY' and cn.n_name = 'FRANCE'));

evaluate 'Case 2: the same rows written as independent conditions keep their plan';
--@queryplan
select /*+ recompile */ count (*) from nat sn, nat cn, fact where sn.id = fact.id and sn.n_name in ('FRANCE', 'GERMANY') and cn.n_name in ('FRANCE', 'GERMANY') and sn.n_name <> cn.n_name;

evaluate 'Case 3: one table keeps its covering index scan: 100 rows';
--@queryplan
select /*+ recompile */ count (*) from pair where (a = 'X' and b = 'Y') or (a = 'Y' and b = 'X');

evaluate 'Case 4: three branches on one table: 150 rows';
select count (*) from pair where (a = 'X' and b = 'Y') or (a = 'Y' and b = 'X') or (a = 'P2' and b = 'Q2');

evaluate 'Case 5: clauses written apart over the same columns: 1000 rows';
select count (*) from pair where (a = 'X' or b = 'Y') and (a = 'X' or b = 'X');

evaluate 'Case 6: an outer join ON condition keeps the null padded rows: 5801 rows';
select count (*) from nat sn left outer join nat cn on ((sn.n_name = 'FRANCE' and cn.n_name = 'GERMANY') or (sn.n_name = 'GERMANY' and cn.n_name = 'FRANCE'));

evaluate 'Case 7: a subquery in one branch is planned once, not once per distributed clause';
--@queryplan
select /*+ recompile */ count (*) from pair where (a = 'X' and b in (select b from pair where id < 100)) or (a = 'Y' and b = 'X');

evaluate 'Case 8: eight branches give a key range on a: 400 rows';
--@queryplan
select /*+ recompile */ count (*) from pair where (a = 'X' and b = 'Y') or (a = 'Y' and b = 'X') or (a = 'P2' and b = 'Q2') or (a = 'P3' and b = 'Q3') or (a = 'P4' and b = 'Q4') or (a = 'P5' and b = 'Q5') or (a = 'P6' and b = 'Q6') or (a = 'P7' and b = 'Q7');

evaluate 'Case 9: a disjunction over a inside a branch still gives the key range: 150 rows';
--@queryplan
select /*+ recompile */ count (*) from pair where ((a = 'X' or a = 'Y') and b = 'Y') or (a = 'P2' and b = 'Q2');

evaluate 'Case 10: restrictions derived from an ON condition, on the inner side and on the preserved side';
select count (*) from nat sn left outer join nat cn on sn.id = cn.id + 1 and ((sn.n_name = 'FRANCE' and cn.n_name = 'FRANCE') or (sn.n_name = 'GERMANY' and cn.n_name = 'GERMANY'));
select count (*) from nat sn left outer join nat cn on sn.id = cn.id and ((sn.n_name = 'FRANCE' and sn.id < 30) or (sn.n_name = 'GERMANY' and sn.id > 60));
select count (*) from nat sn right outer join nat cn on sn.id = cn.id and ((sn.n_name = 'FRANCE' and cn.id < 30) or (sn.n_name = 'GERMANY' and cn.id > 60));
select count (*) from nat sn left outer join nat cn on sn.id = cn.id and ((sn.n_name = 'FRANCE' and sn.id < 30) or (sn.n_name = 'GERMANY' and sn.id > 60)) where cn.id is not null;

evaluate 'Case 11: an ON condition of an UPDATE/DELETE subquery keeps its user range when literals stay literals';
drop table if exists rt, ro, ri;
create table rt (id int, v int);
create table ro (id int);
create table ri (oid int, b int, c int);
insert into rt values (1, 0), (2, 0);
insert into ro values (1), (2);
insert into ri values (1, 1, 1), (2, 3, 2);
set system parameters 'hostvar_late_binding=yes';
update rt set v = (select max (ri.c) from ro left join ri on ro.id = ri.oid and ri.b >= 2 and ((ri.b = 1 and ri.c = 1) or (ri.b = 3 and ri.c = 2)) where ro.id = rt.id);
select id, v from rt order by id;
delete from rt where rt.id in (select ri.c from ro left join ri on ro.id = ri.oid and ri.b >= 2 and ((ri.b = 1 and ri.c = 1) or (ri.b = 3 and ri.c = 2)));
select id from rt order by id;
set system parameters 'hostvar_late_binding=no';
drop table rt, ro, ri;

evaluate 'Case 12: an INNER JOIN ON condition after an outer join does not filter the null-supplying side: 0 rows';
drop table if exists jo, ji, jj;
create table jo (id int);
create table ji (oid int, x int);
create table jj (y int);
insert into jo values (1);
insert into ji values (1, 5);
insert into jj values (1);
select jo.id, ji.x, jj.y from jo left join ji on jo.id = ji.oid inner join jj on (ji.x is null and jj.y = 1) or (ji.x = 2 and jj.y = 2) or (ji.x = 3 and jj.y = 3);
drop table jo, ji, jj;

evaluate 'Case 13: a (+) predicate inside an OR factor still joins as an outer join: 2 rows';
drop table if exists po, pi;
create table po (id int);
create table pi (id int, y int, z int);
insert into po values (1), (2);
insert into pi values (1, 10, 20);
select po.id, pi.y from po, pi where po.id = pi.id(+) and ((pi.y(+) = 10 and pi.z(+) = 20) or pi.y(+) = 99) order by 1;
select po.id, pi.y from po left join pi on po.id = pi.id and ((pi.y = 10 and pi.z = 20) or pi.y = 99) order by 1;
drop table po, pi;

evaluate 'Case 14: a hierarchical query with an OR factor ahead of other WHERE terms: 3 rows';
drop table if exists hq;
create table hq (id int, p int, a int, b int, c int);
insert into hq values (1, null, 1, 1, 1), (2, 1, 2, 2, 1), (3, 2, 1, 1, 1);
select id from hq where ((a = 1 and b = 1) or (a = 2 and b = 2)) and c > 0 start with p is null connect by prior id = p order by id;
select id from hq where c > 0 and ((a = 1 and b = 1) or (a = 2 and b = 2)) start with p is null connect by prior id = p order by id;
drop table hq;

evaluate 'Case 15: a long chain of disjuncts after a conjunction is distributed as before: 2 and 2';
drop table if exists rdeep;
create table rdeep (x int, y int, a int);
insert into rdeep values (1, 1, 0), (0, 0, 7);
select count (*) from rdeep where (x = 1 and y = 1) or a = 1 or a = 2 or a = 3 or a = 4 or a = 5 or a = 6 or a = 7 or a = 8 or a = 9 or a = 10 or a = 11 or a = 12 or a = 13 or a = 14 or a = 15 or a = 16 or a = 17 or a = 18 or a = 19 or a = 20 or a = 21 or a = 22 or a = 23 or a = 24 or a = 25 or a = 26 or a = 27 or a = 28 or a = 29 or a = 30 or a = 31 or a = 32 or a = 33 or a = 34 or a = 35 or a = 36 or a = 37 or a = 38 or a = 39 or a = 40 or a = 41 or a = 42 or a = 43 or a = 44 or a = 45 or a = 46 or a = 47 or a = 48 or a = 49 or a = 50 or a = 51 or a = 52 or a = 53 or a = 54 or a = 55 or a = 56 or a = 57 or a = 58 or a = 59 or a = 60 or a = 61 or a = 62 or a = 63 or a = 64 or a = 65 or a = 66 or a = 67 or a = 68 or a = 69 or a = 70 or a = 71 or a = 72 or a = 73 or a = 74 or a = 75 or a = 76 or a = 77 or a = 78 or a = 79 or a = 80 or a = 81 or a = 82 or a = 83 or a = 84 or a = 85 or a = 86 or a = 87 or a = 88 or a = 89 or a = 90 or a = 91 or a = 92 or a = 93 or a = 94 or a = 95 or a = 96 or a = 97 or a = 98 or a = 99 or a = 100 or a = 101 or a = 102 or a = 103 or a = 104 or a = 105 or a = 106 or a = 107 or a = 108 or a = 109 or a = 110 or a = 111 or a = 112 or a = 113 or a = 114 or a = 115 or a = 116 or a = 117 or a = 118 or a = 119 or a = 120 or a = 121 or a = 122 or a = 123 or a = 124 or a = 125 or a = 126 or a = 127 or a = 128 or a = 129 or a = 130 or a = 131 or a = 132 or a = 133 or a = 134 or a = 135 or a = 136 or a = 137 or a = 138 or a = 139 or a = 140 or a = 141 or a = 142 or a = 143 or a = 144 or a = 145 or a = 146 or a = 147 or a = 148 or a = 149 or a = 150 or a = 151 or a = 152 or a = 153 or a = 154 or a = 155 or a = 156 or a = 157 or a = 158 or a = 159 or a = 160 or a = 161 or a = 162 or a = 163 or a = 164 or a = 165 or a = 166 or a = 167 or a = 168 or a = 169 or a = 170 or a = 171 or a = 172 or a = 173 or a = 174 or a = 175 or a = 176 or a = 177 or a = 178 or a = 179 or a = 180 or a = 181 or a = 182 or a = 183 or a = 184 or a = 185 or a = 186 or a = 187 or a = 188 or a = 189 or a = 190 or a = 191 or a = 192 or a = 193 or a = 194 or a = 195 or a = 196 or a = 197 or a = 198 or a = 199 or a = 200 or a = 201 or a = 202 or a = 203 or a = 204 or a = 205 or a = 206 or a = 207 or a = 208 or a = 209 or a = 210 or a = 211 or a = 212 or a = 213 or a = 214 or a = 215 or a = 216 or a = 217 or a = 218 or a = 219 or a = 220 or a = 221 or a = 222 or a = 223 or a = 224 or a = 225 or a = 226 or a = 227 or a = 228 or a = 229 or a = 230 or a = 231 or a = 232 or a = 233 or a = 234 or a = 235 or a = 236 or a = 237 or a = 238 or a = 239 or a = 240 or a = 241 or a = 242 or a = 243 or a = 244 or a = 245 or a = 246 or a = 247 or a = 248 or a = 249 or a = 250 or a = 251 or a = 252 or a = 253 or a = 254 or a = 255 or a = 256 or a = 257 or a = 258 or a = 259 or a = 260 or a = 261 or a = 262 or a = 263 or a = 264 or a = 265 or a = 266 or a = 267 or a = 268 or a = 269 or a = 270 or a = 271 or a = 272 or a = 273 or a = 274 or a = 275 or a = 276 or a = 277 or a = 278 or a = 279 or a = 280 or a = 281 or a = 282 or a = 283 or a = 284 or a = 285 or a = 286 or a = 287 or a = 288 or a = 289 or a = 290 or a = 291 or a = 292 or a = 293 or a = 294 or a = 295 or a = 296 or a = 297 or a = 298 or a = 299 or a = 300 or a = 301 or a = 302 or a = 303 or a = 304 or a = 305 or a = 306 or a = 307 or a = 308 or a = 309 or a = 310 or a = 311 or a = 312 or a = 313 or a = 314 or a = 315 or a = 316 or a = 317 or a = 318 or a = 319 or a = 320 or a = 321 or a = 322 or a = 323 or a = 324 or a = 325 or a = 326 or a = 327 or a = 328 or a = 329 or a = 330 or a = 331 or a = 332 or a = 333 or a = 334 or a = 335 or a = 336 or a = 337 or a = 338 or a = 339 or a = 340 or a = 341 or a = 342 or a = 343 or a = 344 or a = 345 or a = 346 or a = 347 or a = 348 or a = 349 or a = 350 or a = 351 or a = 352 or a = 353 or a = 354 or a = 355 or a = 356 or a = 357 or a = 358 or a = 359 or a = 360 or a = 361 or a = 362 or a = 363 or a = 364 or a = 365 or a = 366 or a = 367 or a = 368 or a = 369 or a = 370 or a = 371 or a = 372 or a = 373 or a = 374 or a = 375 or a = 376 or a = 377 or a = 378 or a = 379 or a = 380 or a = 381 or a = 382 or a = 383 or a = 384 or a = 385 or a = 386 or a = 387 or a = 388 or a = 389 or a = 390 or a = 391 or a = 392 or a = 393 or a = 394 or a = 395 or a = 396 or a = 397 or a = 398 or a = 399 or a = 400 or a = 401 or a = 402 or a = 403 or a = 404 or a = 405 or a = 406 or a = 407 or a = 408 or a = 409 or a = 410 or a = 411 or a = 412 or a = 413 or a = 414 or a = 415 or a = 416 or a = 417 or a = 418 or a = 419 or a = 420 or a = 421 or a = 422 or a = 423 or a = 424 or a = 425 or a = 426 or a = 427 or a = 428 or a = 429 or a = 430 or a = 431 or a = 432 or a = 433 or a = 434 or a = 435 or a = 436 or a = 437 or a = 438 or a = 439 or a = 440 or a = 441 or a = 442 or a = 443 or a = 444 or a = 445 or a = 446 or a = 447 or a = 448 or a = 449 or a = 450;
select count (*) from rdeep where a = 1 or a = 2 or a = 3 or a = 4 or a = 5 or a = 6 or a = 7 or a = 8 or a = 9 or a = 10 or a = 11 or a = 12 or a = 13 or a = 14 or a = 15 or a = 16 or a = 17 or a = 18 or a = 19 or a = 20 or a = 21 or a = 22 or a = 23 or a = 24 or a = 25 or a = 26 or a = 27 or a = 28 or a = 29 or a = 30 or a = 31 or a = 32 or a = 33 or a = 34 or a = 35 or a = 36 or a = 37 or a = 38 or a = 39 or a = 40 or a = 41 or a = 42 or a = 43 or a = 44 or a = 45 or a = 46 or a = 47 or a = 48 or a = 49 or a = 50 or a = 51 or a = 52 or a = 53 or a = 54 or a = 55 or a = 56 or a = 57 or a = 58 or a = 59 or a = 60 or a = 61 or a = 62 or a = 63 or a = 64 or a = 65 or a = 66 or a = 67 or a = 68 or a = 69 or a = 70 or a = 71 or a = 72 or a = 73 or a = 74 or a = 75 or a = 76 or a = 77 or a = 78 or a = 79 or a = 80 or a = 81 or a = 82 or a = 83 or a = 84 or a = 85 or a = 86 or a = 87 or a = 88 or a = 89 or a = 90 or a = 91 or a = 92 or a = 93 or a = 94 or a = 95 or a = 96 or a = 97 or a = 98 or a = 99 or a = 100 or a = 101 or a = 102 or a = 103 or a = 104 or a = 105 or a = 106 or a = 107 or a = 108 or a = 109 or a = 110 or a = 111 or a = 112 or a = 113 or a = 114 or a = 115 or a = 116 or a = 117 or a = 118 or a = 119 or a = 120 or a = 121 or a = 122 or a = 123 or a = 124 or a = 125 or a = 126 or a = 127 or a = 128 or a = 129 or a = 130 or a = 131 or a = 132 or a = 133 or a = 134 or a = 135 or a = 136 or a = 137 or a = 138 or a = 139 or a = 140 or a = 141 or a = 142 or a = 143 or a = 144 or a = 145 or a = 146 or a = 147 or a = 148 or a = 149 or a = 150 or a = 151 or a = 152 or a = 153 or a = 154 or a = 155 or a = 156 or a = 157 or a = 158 or a = 159 or a = 160 or a = 161 or a = 162 or a = 163 or a = 164 or a = 165 or a = 166 or a = 167 or a = 168 or a = 169 or a = 170 or a = 171 or a = 172 or a = 173 or a = 174 or a = 175 or a = 176 or a = 177 or a = 178 or a = 179 or a = 180 or a = 181 or a = 182 or a = 183 or a = 184 or a = 185 or a = 186 or a = 187 or a = 188 or a = 189 or a = 190 or a = 191 or a = 192 or a = 193 or a = 194 or a = 195 or a = 196 or a = 197 or a = 198 or a = 199 or a = 200 or a = 201 or a = 202 or a = 203 or a = 204 or a = 205 or a = 206 or a = 207 or a = 208 or a = 209 or a = 210 or a = 211 or a = 212 or a = 213 or a = 214 or a = 215 or a = 216 or a = 217 or a = 218 or a = 219 or a = 220 or a = 221 or a = 222 or a = 223 or a = 224 or a = 225 or a = 226 or a = 227 or a = 228 or a = 229 or a = 230 or a = 231 or a = 232 or a = 233 or a = 234 or a = 235 or a = 236 or a = 237 or a = 238 or a = 239 or a = 240 or a = 241 or a = 242 or a = 243 or a = 244 or a = 245 or a = 246 or a = 247 or a = 248 or a = 249 or a = 250 or a = 251 or a = 252 or a = 253 or a = 254 or a = 255 or a = 256 or a = 257 or a = 258 or a = 259 or a = 260 or a = 261 or a = 262 or a = 263 or a = 264 or a = 265 or a = 266 or a = 267 or a = 268 or a = 269 or a = 270 or a = 271 or a = 272 or a = 273 or a = 274 or a = 275 or a = 276 or a = 277 or a = 278 or a = 279 or a = 280 or a = 281 or a = 282 or a = 283 or a = 284 or a = 285 or a = 286 or a = 287 or a = 288 or a = 289 or a = 290 or a = 291 or a = 292 or a = 293 or a = 294 or a = 295 or a = 296 or a = 297 or a = 298 or a = 299 or a = 300 or a = 301 or a = 302 or a = 303 or a = 304 or a = 305 or a = 306 or a = 307 or a = 308 or a = 309 or a = 310 or a = 311 or a = 312 or a = 313 or a = 314 or a = 315 or a = 316 or a = 317 or a = 318 or a = 319 or a = 320 or a = 321 or a = 322 or a = 323 or a = 324 or a = 325 or a = 326 or a = 327 or a = 328 or a = 329 or a = 330 or a = 331 or a = 332 or a = 333 or a = 334 or a = 335 or a = 336 or a = 337 or a = 338 or a = 339 or a = 340 or a = 341 or a = 342 or a = 343 or a = 344 or a = 345 or a = 346 or a = 347 or a = 348 or a = 349 or a = 350 or a = 351 or a = 352 or a = 353 or a = 354 or a = 355 or a = 356 or a = 357 or a = 358 or a = 359 or a = 360 or a = 361 or a = 362 or a = 363 or a = 364 or a = 365 or a = 366 or a = 367 or a = 368 or a = 369 or a = 370 or a = 371 or a = 372 or a = 373 or a = 374 or a = 375 or a = 376 or a = 377 or a = 378 or a = 379 or a = 380 or a = 381 or a = 382 or a = 383 or a = 384 or a = 385 or a = 386 or a = 387 or a = 388 or a = 389 or a = 390 or a = 391 or a = 392 or a = 393 or a = 394 or a = 395 or a = 396 or a = 397 or a = 398 or a = 399 or a = 400 or a = 401 or a = 402 or a = 403 or a = 404 or a = 405 or a = 406 or a = 407 or a = 408 or a = 409 or a = 410 or a = 411 or a = 412 or a = 413 or a = 414 or a = 415 or a = 416 or a = 417 or a = 418 or a = 419 or a = 420 or a = 421 or a = 422 or a = 423 or a = 424 or a = 425 or a = 426 or a = 427 or a = 428 or a = 429 or a = 430 or a = 431 or a = 432 or a = 433 or a = 434 or a = 435 or a = 436 or a = 437 or a = 438 or a = 439 or a = 440 or a = 441 or a = 442 or a = 443 or a = 444 or a = 445 or a = 446 or a = 447 or a = 448 or a = 449 or a = 450 or (x = 1 and y = 1);
drop table rdeep;

evaluate 'Case 16: each branch bounding the same column on both sides gives a key range on it: 2 rows';
drop table if exists rd;
create table rd (d int, k int);
create index i_rd_d on rd (d);
insert into rd select rownum, mod (rownum, 10) from db_class a, db_class b, db_class c limit 20000;
update statistics on rd with fullscan;
--@queryplan
select /*+ recompile */ count (*) from rd where (d >= 10 and d < 20 and k = 1) or (d >= 50 and d < 60 and k = 2);
drop table rd;

evaluate 'Case 17: a subquery ahead of another table''s conjunct does not hide it: the same plan in either order';
drop table if exists so, si, ss;
create table so (a int);
create table si (b int);
create index i_si_b on si (b);
create table ss (x int);
insert into so select mod (rownum, 10) from db_class a, db_class b limit 300;
insert into si select rownum from db_class a, db_class b, db_class c limit 10000;
insert into ss values (1), (2);
update statistics on so with fullscan;
update statistics on si with fullscan;
update statistics on ss with fullscan;
--@queryplan
select /*+ recompile */ count (*) from so, si where (so.a in (select x from ss) and si.b = 1) or (so.a = 2 and si.b = 3);
--@queryplan
select /*+ recompile */ count (*) from so, si where (si.b = 1 and so.a in (select x from ss)) or (si.b = 3 and so.a = 2);
drop table so, si, ss;

evaluate 'Case 18: HAVING is distributed as before, so the group column filters the scan: 2 rows';
drop table if exists hg;
create table hg (g int, x int);
create index i_hg_g on hg (g);
insert into hg select mod (rownum, 1000), rownum from db_class a, db_class b, db_class c limit 20000;
update statistics on hg with fullscan;
--@queryplan
select /*+ recompile */ g, sum (x) from hg group by g having (g = 1 and sum (x) > 10) or (g = 2 and sum (x) > 20) order by g;
drop table hg;

drop table nat, fact, pair;
