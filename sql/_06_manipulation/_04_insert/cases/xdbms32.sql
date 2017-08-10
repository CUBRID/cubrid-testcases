-- xdbms32 issue test
drop table covbr;
create table covbr (
     version              VARCHAR(20) NOT NULL ,
     directory            VARCHAR(50) NOT NULL ,
     src_name             VARCHAR(100) NOT NULL, 
     src_content          VARCHAR ,
     regdate              DATE    ,
     PRIMARY KEY (version,directory,src_name)
 ) ;


insert into covbr(version,directory,src_name,src_content, regdate) values( '20080708', '../build/src/', 'parse.c', '


  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    
    
    <link rel="stylesheet" href="../../_static/default.css" type="text/css" />
    <link rel="stylesheet" href="../../_static/pygments.css" type="text/css" />
    
    <script type="text/javascript">
      var DOCUMENTATION_OPTIONS = {
        URL_ROOT:    '../../',
        VERSION:     '9.3.0',
        COLLAPSE_INDEX: false,
        FILE_SUFFIX: '.html',
        HAS_SOURCE:  true
      };
    </script>
    <script type="text/javascript" src="../../_static/jquery.js"></script>
    <script type="text/javascript" src="../../_static/underscore.js"></script>
    <script type="text/javascript" src="../../_static/doctools.js"></script>
    <link rel="up" title="Data Manipulation" href="index.html" />
    <link rel="next" title="UPDATE" href="update.html" />
    <link rel="prev" title="Hierarchical Query" href="hq.html" /> 
    <script type="text/javascript">
        if(!wcs_add) var wcs_add = {};
        wcs_add["wa"] = "195d9567225f24";
        wcs_do();
    </script>

  </head>
  <body>
    <div class="related">
      <h3>Navigation</h3>
      <ul>
        <li class="right" style="margin-right: 10px">
          <a href="../../genindex.html" title="General Index"
             accesskey="I">index</a></li>
        <li class="right" >
          <a href="update.html" title="UPDATE"
             accesskey="N">next</a> |</li>
        <li class="right" >
          <a href="hq.html" title="Hierarchical Query"
             accesskey="P">previous</a> |</li>
        <li><a href="../../index.html">CUBRID 9.3.0 documentation</a> &raquo;</li>
          <li><a href="../index.html" >CUBRID SQL Guide</a> &raquo;</li>
          <li><a href="index.html" accesskey="U">Data Manipulation</a> &raquo;</li> 
      </ul>
    </div>  

    <div class="document">
      <div class="documentwrapper">
        <div class="bodywrapper">
          <div class="body">
            
  <div class="section" id="insert">
<h1>INSERT<a class="headerlink" href="#insert" title="Permalink to this headline">¶</a></h1>
<p>You can insert a new record into a table in a database by using the <strong>INSERT</strong> statement. CUBRID supports <strong>INSERT ... VALUES</strong>, <strong>INSERT ... SET</strong> and <strong>INSERT ... SELECT</strong> statements.</p>
<p><strong>INSERT ... VALUES</strong> and <strong>INSERT ... SET</strong> statements are used to insert a new record based on the value that is explicitly specified while the <strong>INSERT ... SELECT</strong> statement is used to insert query result records obtained from different tables. Use the <strong>INSERT VALUES</strong> or <strong>INSERT ... SELECT</strong> statement to insert multiple rows by using the single <strong>INSERT</strong> statement.</p>
<div class="highlight-python"><div class="highlight"><pre>&lt;INSERT ... VALUES statement&gt;
INSERT [INTO] table_name [(column_name, ...)]
    {VALUES | VALUE}({expr | DEFAULT}, ...)[,({expr | DEFAULT}, ...),...]
    [ON DUPLICATE KEY UPDATE column_name = expr, ... ]
INSERT [INTO] table_name DEFAULT [ VALUES ]

&lt;INSERT ... SET statement&gt;
INSERT [INTO] table_name
    SET column_name = {expr | DEFAULT}[, column_name = {expr | DEFAULT},...]
    [ON DUPLICATE KEY UPDATE column_name = expr, ... ]

&lt;INSERT ... SELECT statement&gt;
INSERT [INTO] table_name [(column_name, ...)]
    SELECT...
    [ON DUPLICATE KEY UPDATE column_name = expr, ... ]
</pre></div>
</div>
<ul class="simple">
<li><em>table_name</em>: Specifies the name of the target table into which you want to insert a new record.</li>
<li><em>column_name</em>: Specifies the name of the column into which you want to insert the value. If you omit to specify the column name, it is considered that all columns defined in the table have been specified. Therefore, you must specify the values for all columns next to the <strong>VALUES</strong> keyword. If you do not specify all the columns defined in the table, a <strong>DEFAULT</strong> value is assigned to the non-specified columns; if the <strong>DEFAULT</strong> value is not defined, a <strong>NULL</strong> value is assigned.</li>
<li><em>expr</em> | <strong>DEFAULT</strong>: Specifies values that correspond to the columns next to the <strong>VALUES</strong> keyword. Expressions or the <strong>DEFAULT</strong> keyword can be specified as a value. At this time, the order and number of the specified column list must correspond to the column value list. The column value list for a single record is described in parentheses.</li>
<li><strong>DEFAULT</strong>: You can use the <strong>DEFAULT</strong> keyword to specify a default value as the column value. If you specify <strong>DEFAULT</strong> in the column value list next to the <strong>VALUES</strong> keyword, a default value column is stored for the given column: if you specify <strong>DEFAULT</strong> before the <strong>VALUES</strong> keyword, default values are stored for all columns in the table. <strong>NULL</strong> is stored for the column whose default value has not been defined.</li>
<li><strong>ON DUPLICATE KEY UPDATE</strong>: In case constraints are violated because a duplicated value for a column where <strong>PRIMARY KEY</strong> or <strong>UNIQUE</strong> attribute is defined is inserted, the value that makes constraints violated is changed into a specific value by performing the action specified in the <strong>ON DUPLICATE KEY UPDATE</strong> statement.</li>
</ul>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">a_tbl1</span><span class="p">(</span>
    <span class="n">id</span> <span class="nb">INT</span> <span class="k">UNIQUE</span><span class="p">,</span>
    <span class="n">name</span> <span class="nb">VARCHAR</span><span class="p">,</span>
    <span class="n">phone</span> <span class="nb">VARCHAR</span> <span class="k">DEFAULT</span> <span class="s1">&#39;000-0000&#39;</span>
<span class="p">);</span>

<span class="c1">--insert default values with DEFAULT keyword before VALUES</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">DEFAULT</span> <span class="k">VALUES</span><span class="p">;</span>

<span class="c1">--insert multiple rows</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">VALUES</span> <span class="p">(</span><span class="mi">1</span><span class="p">,</span><span class="s1">&#39;aaa&#39;</span><span class="p">,</span> <span class="k">DEFAULT</span><span class="p">),(</span><span class="mi">2</span><span class="p">,</span><span class="s1">&#39;bbb&#39;</span><span class="p">,</span> <span class="k">DEFAULT</span><span class="p">);</span>

<span class="c1">--insert a single row specifying column values for all</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">VALUES</span> <span class="p">(</span><span class="mi">3</span><span class="p">,</span><span class="s1">&#39;ccc&#39;</span><span class="p">,</span> <span class="s1">&#39;333-3333&#39;</span><span class="p">);</span>

<span class="c1">--insert two rows specifying column values for only</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span><span class="p">(</span><span class="n">id</span><span class="p">)</span> <span class="k">VALUES</span> <span class="p">(</span><span class="mi">4</span><span class="p">),</span> <span class="p">(</span><span class="mi">5</span><span class="p">);</span>

<span class="c1">--insert a single row with SET clauses</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">SET</span> <span class="n">id</span><span class="o">=</span><span class="mi">6</span><span class="p">,</span> <span class="n">name</span><span class="o">=</span><span class="s1">&#39;eee&#39;</span><span class="p">;</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">SET</span> <span class="n">id</span><span class="o">=</span><span class="mi">7</span><span class="p">,</span> <span class="n">phone</span><span class="o">=</span><span class="s1">&#39;777-7777&#39;</span><span class="p">;</span>

<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
         NULL  NULL                  &#39;000-0000&#39;
            1  &#39;aaa&#39;                 &#39;000-0000&#39;
            2  &#39;bbb&#39;                 &#39;000-0000&#39;
            3  &#39;ccc&#39;                 &#39;333-3333&#39;
            4  NULL                  &#39;000-0000&#39;
            5  NULL                  &#39;000-0000&#39;
            6  &#39;eee&#39;                 &#39;000-0000&#39;
            7  NULL                  &#39;777-7777&#39;
</pre></div>
</div>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">SET</span> <span class="n">id</span><span class="o">=</span><span class="mi">6</span><span class="p">,</span> <span class="n">phone</span><span class="o">=</span><span class="s1">&#39;000-0000&#39;</span>
<span class="k">ON</span> <span class="n">DUPLICATE</span> <span class="k">KEY</span> <span class="k">UPDATE</span> <span class="n">phone</span><span class="o">=</span><span class="s1">&#39;666-6666&#39;</span><span class="p">;</span>
<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">id</span><span class="o">=</span><span class="mi">6</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
            6  &#39;eee&#39;                 &#39;666-6666&#39;
</pre></div>
</div>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">id</span><span class="o">=</span><span class="mi">7</span> <span class="k">ON</span> <span class="n">DUPLICATE</span> <span class="k">KEY</span> <span class="k">UPDATE</span> <span class="n">name</span><span class="o">=</span><span class="s1">&#39;ggg&#39;</span><span class="p">;</span>
<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">id</span><span class="o">=</span><span class="mi">7</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
            7  &#39;ggg&#39;                 &#39;777-7777&#39;
</pre></div>
</div>
<p>In <strong>INSERT ... SET</strong> syntax, the evaluation of an assignment expression is performed from left to right. If the column value is not specified, then the default value is assigned. If there is no default value, <strong>NULL</strong> is assigned.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">tbl</span> <span class="p">(</span><span class="n">a</span> <span class="nb">INT</span><span class="p">,</span> <span class="n">b</span> <span class="nb">INT</span><span class="p">,</span> <span class="k">c</span> <span class="nb">INT</span><span class="p">);</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">tbl</span> <span class="k">SET</span> <span class="n">a</span><span class="o">=</span><span class="mi">1</span><span class="p">,</span> <span class="n">b</span><span class="o">=</span><span class="n">a</span><span class="o">+</span><span class="mi">1</span><span class="p">,</span> <span class="k">c</span><span class="o">=</span><span class="n">b</span><span class="o">+</span><span class="mi">2</span><span class="p">;</span>
<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">tbl</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>        a            b            c
===================================
        1            2            4
</pre></div>
</div>
<p>In the above example, b's value will be 2 and c's value will be 4 since a's value is 1.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">tbl2</span> <span class="p">(</span><span class="n">a</span> <span class="nb">INT</span><span class="p">,</span> <span class="n">b</span> <span class="nb">INT</span><span class="p">,</span> <span class="k">c</span> <span class="nb">INT</span><span class="p">);</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">tbl2</span> <span class="k">SET</span> <span class="n">a</span><span class="o">=</span><span class="n">b</span><span class="o">+</span><span class="mi">1</span><span class="p">,</span> <span class="n">b</span><span class="o">=</span><span class="mi">1</span><span class="p">,</span> <span class="k">c</span><span class="o">=</span><span class="n">b</span><span class="o">+</span><span class="mi">2</span><span class="p">;</span>
</pre></div>
</div>
<p>In the above example, a's value will be <strong>NULL</strong> since b's value is not specified yet when assigning a's value.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">tbl2</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>        a            b            c
===================================
     NULL            1            3
</pre></div>
</div>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">tbl3</span> <span class="p">(</span><span class="n">a</span> <span class="nb">INT</span><span class="p">,</span> <span class="n">b</span> <span class="nb">INT</span> <span class="k">default</span> <span class="mi">10</span><span class="p">,</span> <span class="k">c</span> <span class="nb">INT</span><span class="p">);</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">tbl3</span> <span class="k">SET</span> <span class="n">a</span><span class="o">=</span><span class="n">b</span><span class="o">+</span><span class="mi">1</span><span class="p">,</span> <span class="n">b</span><span class="o">=</span><span class="mi">1</span><span class="p">,</span> <span class="k">c</span><span class="o">=</span><span class="n">b</span><span class="o">+</span><span class="mi">2</span><span class="p">;</span>
</pre></div>
</div>
<p>In the above example, a's value will be 11 since b's value is not specified yet and b's default is 10.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">tbl3</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>        a            b            c
===================================
       11            1            3
</pre></div>
</div>
<div class="section" id="insert-select-statement">
<h2>INSERT ... SELECT Statement<a class="headerlink" href="#insert-select-statement" title="Permalink to this headline">¶</a></h2>
<p>If you use the <strong>SELECT</strong> query in the <strong>INSERT</strong> statement, you can insert query results which satisfy the specified retrieval condition from one or many tables to the target table.</p>
<div class="highlight-python"><div class="highlight"><pre>INSERT [INTO] table_name [(column_name, ...)]
    SELECT...
    [ON DUPLICATE KEY UPDATE column_name = expr, ... ]
</pre></div>
</div>
<p>The <strong>SELECT</strong> statement can be used in place of the <strong>VALUES</strong> keyword, or be included as a subquery in the column value list next to <strong>VALUES</strong>. If you specify the <strong>SELECT</strong> statement in place of the <strong>VALUES</strong> keyword, you can insert multiple query result records into the column of the table at once. However, there should be only one query result record if the <strong>SELECT</strong> statement is specified in the column value list.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="c1">--creating an empty table which schema replicated from a_tbl1</span>
<span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">a_tbl2</span> <span class="k">LIKE</span> <span class="n">a_tbl1</span><span class="p">;</span>

<span class="c1">--inserting multiple rows from SELECT query results</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl2</span> <span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">id</span> <span class="k">IS</span> <span class="k">NOT</span> <span class="k">NULL</span><span class="p">;</span>

<span class="c1">--inserting column value with SELECT subquery specified in the value list</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl2</span> <span class="k">VALUES</span><span class="p">(</span><span class="mi">8</span><span class="p">,</span> <span class="k">SELECT</span> <span class="n">name</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">name</span> <span class="o">&lt;</span><span class="s1">&#39;bbb&#39;</span><span class="p">,</span> <span class="k">DEFAULT</span><span class="p">);</span>

<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl2</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
            1  &#39;aaa&#39;                 &#39;000-0000&#39;
            2  &#39;bbb&#39;                 &#39;000-0000&#39;
            3  &#39;ccc&#39;                 &#39;333-3333&#39;
            4  NULL                  &#39;000-0000&#39;
            5  NULL                  &#39;000-0000&#39;
            6  &#39;eee&#39;                 &#39;000-0000&#39;
            7  NULL                  &#39;777-7777&#39;
            8  &#39;aaa&#39;                 &#39;000-0000&#39;
</pre></div>
</div>
</div>
<div class="section" id="on-duplicate-key-update-clause">
<h2>ON DUPLICATE KEY UPDATE Clause<a class="headerlink" href="#on-duplicate-key-update-clause" title="Permalink to this headline">¶</a></h2>
<p>In a situation in which a duplicate value is inserted into a column for which the <strong>UNIQUE</strong> index or the <strong>PRIMARY KEY</strong> constraint has been set, you can update to a new value by specifying the <strong>ON DUPLICATE KEY UPDATE</strong> clause in the <strong>INSERT</strong> statement.</p>
<div class="admonition note">
<p class="first admonition-title">Note</p>
<ul class="last simple">
<li>If <strong>PRIMARY KEY</strong> and <strong>UNIQUE</strong> or multiple <strong>UNIQUE</strong> constraints exist on a table together, constraint violation can happen by one of them; so in this case, <strong>ON DUPLICATE KEY UPDATE</strong> clause is not recommended.</li>
<li>Even if <strong>UPDATE</strong> is executed after failing executing <strong>INSERT</strong>, <strong>AUTO_INCREMENT</strong> value which is increased once cannot be rolled back into the previous value.</li>
</ul>
</div>
<div class="highlight-python"><div class="highlight"><pre>&lt;INSERT ... VALUES statement&gt;
&lt;INSERT ... SET statement&gt;
&lt;INSERT ... SELECT statement&gt;
    INSERT ...
    [ON DUPLICATE KEY UPDATE column_name = expr, ... ]
</pre></div>
</div>
<ul class="simple">
<li><em>column_name</em> = <em>expr</em>: Specifies the name of the column whose value you want to change next to <strong>ON DUPLICATE KEY UPDATE</strong> and a new column value by using the equal sign.</li>
</ul>
<div class="highlight-sql"><div class="highlight"><pre><span class="c1">--creating a new table having the same schema as a_tbl1</span>
<span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">a_tbl3</span> <span class="k">LIKE</span> <span class="n">a_tbl1</span><span class="p">;</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl3</span> <span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">id</span> <span class="k">IS</span> <span class="k">NOT</span> <span class="k">NULL</span> <span class="k">and</span> <span class="n">name</span> <span class="k">IS</span> <span class="k">NOT</span> <span class="k">NULL</span><span class="p">;</span>
<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl3</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
            1  &#39;aaa&#39;                 &#39;000-0000&#39;
            2  &#39;bbb&#39;                 &#39;000-0000&#39;
            3  &#39;ccc&#39;                 &#39;333-3333&#39;
            6  &#39;eee&#39;                 &#39;000-0000&#39;
</pre></div>
</div>
<div class="highlight-sql"><div class="highlight"><pre><span class="c1">--insert duplicated value violating UNIQUE constraint</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl3</span> <span class="k">VALUES</span><span class="p">(</span><span class="mi">2</span><span class="p">,</span> <span class="s1">&#39;bbb&#39;</span><span class="p">,</span> <span class="s1">&#39;222-2222&#39;</span><span class="p">);</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>ERROR: Operation would have caused one or more unique constraint violations.
</pre></div>
</div>
<p>With ON DUPLICATE KEY UPDATE, &quot;affected rows&quot; value per row will be 1 if a new row is inserted, and 2 if an existing row is updated.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="c1">--insert duplicated value with specifying ON DUPLICATED KEY UPDATE clause</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl3</span> <span class="k">VALUES</span><span class="p">(</span><span class="mi">2</span><span class="p">,</span> <span class="s1">&#39;ggg&#39;</span><span class="p">,</span> <span class="s1">&#39;222-2222&#39;</span><span class="p">)</span>
<span class="k">ON</span> <span class="n">DUPLICATE</span> <span class="k">KEY</span> <span class="k">UPDATE</span> <span class="n">name</span><span class="o">=</span><span class="s1">&#39;ggg&#39;</span><span class="p">,</span> <span class="n">phone</span> <span class="o">=</span> <span class="s1">&#39;222-2222&#39;</span><span class="p">;</span>

<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl3</span> <span class="k">WHERE</span> <span class="n">id</span><span class="o">=</span><span class="mi">2</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
            2  &#39;ggg&#39;                 &#39;222-2222&#39;

2 rows affected.
</pre></div>
</div>
</div>
</div>


          </div>
        </div>
      </div>
    <div class="sphinxsidebar">
        <div class="sphinxsidebarwrapper">
              <h3><a href="../../index.html">Table Of Contents</a></h3>
              <ul class="current">
<li class="toctree-l1"><a class="reference internal" href="../../toc.html">Introduction to Manual</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../intro.html">Introduction to CUBRID</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../install_upgrade.html">Installing and Upgrading</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../start.html">Getting Started</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../csql.html">CSQL Interpreter</a></li>
<li class="toctree-l1 current"><a class="reference internal" href="../index.html">CUBRID SQL Guide</a><ul class="current">
<li class="toctree-l2"><a class="reference internal" href="../identifier.html">Identifier</a></li>
<li class="toctree-l2"><a class="reference internal" href="../keyword.html">Reserved Words</a></li>
<li class="toctree-l2"><a class="reference internal" href="../comment.html">Comment</a></li>
<li class="toctree-l2"><a class="reference internal" href="../datatype.html">Data Types</a></li>
<li class="toctree-l2"><a class="reference internal" href="../schema/table.html">Table</a></li>
<li class="toctree-l2"><a class="reference internal" href="../schema/index.html">Index</a></li>
<li class="toctree-l2"><a class="reference internal" href="../schema/view.html">View</a></li>
<li class="toctree-l2"><a class="reference internal" href="../schema/serial.html">Serial</a></li>
<li class="toctree-l2"><a class="reference internal" href="../authorization.html">Database User Authorization</a></li>
<li class="toctree-l2"><a class="reference internal" href="../function/index.html">Operators and Functions</a></li>
<li class="toctree-l2 current"><a class="reference internal" href="index.html">Data Manipulation</a><ul class="current">
<li class="toctree-l3"><a class="reference internal" href="select.html">SELECT</a></li>
<li class="toctree-l3"><a class="reference internal" href="hq.html">Hierarchical Query</a></li>
<li class="toctree-l3 current"><a class="current reference internal" href="">INSERT</a></li>
<li class="toctree-l3"><a class="reference internal" href="update.html">UPDATE</a></li>
<li class="toctree-l3"><a class="reference internal" href="replace.html">REPLACE</a></li>
<li class="toctree-l3"><a class="reference internal" href="delete.html">DELETE</a></li>
<li class="toctree-l3"><a class="reference internal" href="merge.html">MERGE</a></li>
<li class="toctree-l3"><a class="reference internal" href="truncate.html">TRUNCATE</a></li>
<li class="toctree-l3"><a class="reference internal" href="prepare.html">PREPARED STATEMENT</a></li>
<li class="toctree-l3"><a class="reference internal" href="prepare.html#set">SET</a></li>
<li class="toctree-l3"><a class="reference internal" href="prepare.html#do">DO</a></li>
<li class="toctree-l3"><a class="reference internal" href="show.html">SHOW</a></li>
</ul>
</li>
<li class="toctree-l2"><a class="reference internal" href="../tuning.html">Query Optimization</a></li>
<li class="toctree-l2"><a class="reference internal" href="../partition.html">Partitioning</a></li>
<li class="toctree-l2"><a class="reference internal" href="../i18n.html">Globalization</a></li>
<li class="toctree-l2"><a class="reference internal" href="../transaction.html">Transaction and Lock</a></li>
<li class="toctree-l2"><a class="reference internal" href="../trigger.html">Trigger</a></li>
<li class="toctree-l2"><a class="reference internal" href="../jsp.html">Java Stored Function/Procedure</a></li>
<li class="toctree-l2"><a class="reference internal" href="../method.html">Method</a></li>
<li class="toctree-l2"><a class="reference internal" href="../oodb.html">Class Inheritance</a></li>
<li class="toctree-l2"><a class="reference internal" href="../catalog.html">System Catalog</a></li>
</ul>
</li>
<li class="toctree-l1"><a class="reference internal" href="../../admin/index.html">Administrator's Guide</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../ha.html">CUBRID HA</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../shard.html">CUBRID SHARD</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../api/index.html">API Reference</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../release_note/index.html">Release Notes</a></li>
</ul>

  <h4>Previous topic</h4>
  <p class="topless"><a href="hq.html"
                        title="previous chapter">Hierarchical Query</a></p>
  <h4>Next topic</h4>
  <p class="topless"><a href="update.html"
                        title="next chapter">UPDATE</a></p>
  <h3>This Page</h3>
  <ul class="this-page-menu">
    <li><a href="../../_sources/sql/query/insert.txt"
           rel="nofollow">Show Source</a></li>
  </ul>
          <h3 style="margin-top: 1.5em;">Manual Search</h3>
          <form class="search" action="../../search.html" method="get">
            <input type="text" name="q" size="18" />
            <input type="submit" value="Go" />
            <input type="hidden" name="check_keywords" value="yes" />
            <input type="hidden" name="area" value="default" />
          </form>
          <p class="searchtip" style="font-size: 90%">
            Search Area: Manual. Enter only one keyword.
          </p>

          <h3 style="margin-top: 1.5em;">Site Search</h3>
          <form class="search" action="http://www.cubrid.org/?" method="get">
            <input type="text" name="is_keyword" size="18" />
            <input type="submit" value="Go" />
            <input type="hidden" name="act" value="IS" />
            <input type="hidden" name="search_target" value="title_content" />
          </form>
          <p class="searchtip" style="font-size: 90%">
            Search Area: cubrid.org Site. You can enter several keywords.
          </p>
       </div> 
    </div>
  
      <div class="clearer"></div>
    </div>
    <div class="related">
      <h3>Navigation</h3>
      <ul>
        <li class="right" style="margin-right: 10px">
          <a href="../../genindex.html" title="General Index"
             >index</a></li>
        <li class="right" >
          <a href="update.html" title="UPDATE"
             >next</a> |</li>
        <li class="right" >
          <a href="hq.html" title="Hierarchical Query"
             >previous</a> |</li>
        <li><a href="../../index.html">CUBRID 9.3.0 documentation</a> &raquo;</li>
          <li><a href="../index.html" >CUBRID SQL Guide</a> &raquo;</li>
          <li><a href="index.html" >Data Manipulation</a> &raquo;</li> 
      </ul>
    </div>
    <div class="footer">
        &copy; Copyright 2014, Search Solution Corporation.
      Last updated on Sep 17, 2015.
      Created using <a href="http://sphinx-doc.org/">Sphinx</a> 1.2.2.
    </div>
  </body>
</html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    
    <title>INSERT &mdash; CUBRID 9.3.0 documentation</title>
    
    <link rel="stylesheet" href="../../_static/default.css" type="text/css" />
    <link rel="stylesheet" href="../../_static/pygments.css" type="text/css" />
    
    <script type="text/javascript">
      var DOCUMENTATION_OPTIONS = {
        URL_ROOT:    '../../',
        VERSION:     '9.3.0',
        COLLAPSE_INDEX: false,
        FILE_SUFFIX: '.html',
        HAS_SOURCE:  true
      };
    </script>
    <script type="text/javascript" src="../../_static/jquery.js"></script>
    <script type="text/javascript" src="../../_static/underscore.js"></script>
    <script type="text/javascript" src="../../_static/doctools.js"></script>
    <link rel="top" title="CUBRID 9.3.0 documentation" href="../../index.html" />
    <link rel="up" title="Data Manipulation" href="index.html" />
    <link rel="next" title="UPDATE" href="update.html" />
    <link rel="prev" title="Hierarchical Query" href="hq.html" /> 
    <script type="text/javascript">
        if(!wcs_add) var wcs_add = {};
        wcs_add["wa"] = "195d9567225f24";
        wcs_do();
    </script>

  </head>
  <body>
    <div class="related">
      <h3>Navigation</h3>
      <ul>
        <li class="right" style="margin-right: 10px">
          <a href="../../genindex.html" title="General Index"
             accesskey="I">index</a></li>
        <li class="right" >
          <a href="update.html" title="UPDATE"
             accesskey="N">next</a> |</li>
        <li class="right" >
          <a href="hq.html" title="Hierarchical Query"
             accesskey="P">previous</a> |</li>
        <li><a href="../../index.html">CUBRID 9.3.0 documentation</a> &raquo;</li>
          <li><a href="../index.html" >CUBRID SQL Guide</a> &raquo;</li>
          <li><a href="index.html" accesskey="U">Data Manipulation</a> &raquo;</li> 
      </ul>
    </div>  

    <div class="document">
      <div class="documentwrapper">
        <div class="bodywrapper">
          <div class="body">
            
  <div class="section" id="insert">
<h1>INSERT<a class="headerlink" href="#insert" title="Permalink to this headline">¶</a></h1>
<p>You can insert a new record into a table in a database by using the <strong>INSERT</strong> statement. CUBRID supports <strong>INSERT ... VALUES</strong>, <strong>INSERT ... SET</strong> and <strong>INSERT ... SELECT</strong> statements.</p>
<p><strong>INSERT ... VALUES</strong> and <strong>INSERT ... SET</strong> statements are used to insert a new record based on the value that is explicitly specified while the <strong>INSERT ... SELECT</strong> statement is used to insert query result records obtained from different tables. Use the <strong>INSERT VALUES</strong> or <strong>INSERT ... SELECT</strong> statement to insert multiple rows by using the single <strong>INSERT</strong> statement.</p>
<div class="highlight-python"><div class="highlight"><pre>&lt;INSERT ... VALUES statement&gt;
INSERT [INTO] table_name [(column_name, ...)]
    {VALUES | VALUE}({expr | DEFAULT}, ...)[,({expr | DEFAULT}, ...),...]
    [ON DUPLICATE KEY UPDATE column_name = expr, ... ]
INSERT [INTO] table_name DEFAULT [ VALUES ]

&lt;INSERT ... SET statement&gt;
INSERT [INTO] table_name
    SET column_name = {expr | DEFAULT}[, column_name = {expr | DEFAULT},...]
    [ON DUPLICATE KEY UPDATE column_name = expr, ... ]

&lt;INSERT ... SELECT statement&gt;
INSERT [INTO] table_name [(column_name, ...)]
    SELECT...
    [ON DUPLICATE KEY UPDATE column_name = expr, ... ]
</pre></div>
</div>
<ul class="simple">
<li><em>table_name</em>: Specifies the name of the target table into which you want to insert a new record.</li>
<li><em>column_name</em>: Specifies the name of the column into which you want to insert the value. If you omit to specify the column name, it is considered that all columns defined in the table have been specified. Therefore, you must specify the values for all columns next to the <strong>VALUES</strong> keyword. If you do not specify all the columns defined in the table, a <strong>DEFAULT</strong> value is assigned to the non-specified columns; if the <strong>DEFAULT</strong> value is not defined, a <strong>NULL</strong> value is assigned.</li>
<li><em>expr</em> | <strong>DEFAULT</strong>: Specifies values that correspond to the columns next to the <strong>VALUES</strong> keyword. Expressions or the <strong>DEFAULT</strong> keyword can be specified as a value. At this time, the order and number of the specified column list must correspond to the column value list. The column value list for a single record is described in parentheses.</li>
<li><strong>DEFAULT</strong>: You can use the <strong>DEFAULT</strong> keyword to specify a default value as the column value. If you specify <strong>DEFAULT</strong> in the column value list next to the <strong>VALUES</strong> keyword, a default value column is stored for the given column: if you specify <strong>DEFAULT</strong> before the <strong>VALUES</strong> keyword, default values are stored for all columns in the table. <strong>NULL</strong> is stored for the column whose default value has not been defined.</li>
<li><strong>ON DUPLICATE KEY UPDATE</strong>: In case constraints are violated because a duplicated value for a column where <strong>PRIMARY KEY</strong> or <strong>UNIQUE</strong> attribute is defined is inserted, the value that makes constraints violated is changed into a specific value by performing the action specified in the <strong>ON DUPLICATE KEY UPDATE</strong> statement.</li>
</ul>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">a_tbl1</span><span class="p">(</span>
    <span class="n">id</span> <span class="nb">INT</span> <span class="k">UNIQUE</span><span class="p">,</span>
    <span class="n">name</span> <span class="nb">VARCHAR</span><span class="p">,</span>
    <span class="n">phone</span> <span class="nb">VARCHAR</span> <span class="k">DEFAULT</span> <span class="s1">&#39;000-0000&#39;</span>
<span class="p">);</span>

<span class="c1">--insert default values with DEFAULT keyword before VALUES</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">DEFAULT</span> <span class="k">VALUES</span><span class="p">;</span>

<span class="c1">--insert multiple rows</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">VALUES</span> <span class="p">(</span><span class="mi">1</span><span class="p">,</span><span class="s1">&#39;aaa&#39;</span><span class="p">,</span> <span class="k">DEFAULT</span><span class="p">),(</span><span class="mi">2</span><span class="p">,</span><span class="s1">&#39;bbb&#39;</span><span class="p">,</span> <span class="k">DEFAULT</span><span class="p">);</span>

<span class="c1">--insert a single row specifying column values for all</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">VALUES</span> <span class="p">(</span><span class="mi">3</span><span class="p">,</span><span class="s1">&#39;ccc&#39;</span><span class="p">,</span> <span class="s1">&#39;333-3333&#39;</span><span class="p">);</span>

<span class="c1">--insert two rows specifying column values for only</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span><span class="p">(</span><span class="n">id</span><span class="p">)</span> <span class="k">VALUES</span> <span class="p">(</span><span class="mi">4</span><span class="p">),</span> <span class="p">(</span><span class="mi">5</span><span class="p">);</span>

<span class="c1">--insert a single row with SET clauses</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">SET</span> <span class="n">id</span><span class="o">=</span><span class="mi">6</span><span class="p">,</span> <span class="n">name</span><span class="o">=</span><span class="s1">&#39;eee&#39;</span><span class="p">;</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">SET</span> <span class="n">id</span><span class="o">=</span><span class="mi">7</span><span class="p">,</span> <span class="n">phone</span><span class="o">=</span><span class="s1">&#39;777-7777&#39;</span><span class="p">;</span>

<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
         NULL  NULL                  &#39;000-0000&#39;
            1  &#39;aaa&#39;                 &#39;000-0000&#39;
            2  &#39;bbb&#39;                 &#39;000-0000&#39;
            3  &#39;ccc&#39;                 &#39;333-3333&#39;
            4  NULL                  &#39;000-0000&#39;
            5  NULL                  &#39;000-0000&#39;
            6  &#39;eee&#39;                 &#39;000-0000&#39;
            7  NULL                  &#39;777-7777&#39;
</pre></div>
</div>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">SET</span> <span class="n">id</span><span class="o">=</span><span class="mi">6</span><span class="p">,</span> <span class="n">phone</span><span class="o">=</span><span class="s1">&#39;000-0000&#39;</span>
<span class="k">ON</span> <span class="n">DUPLICATE</span> <span class="k">KEY</span> <span class="k">UPDATE</span> <span class="n">phone</span><span class="o">=</span><span class="s1">&#39;666-6666&#39;</span><span class="p">;</span>
<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">id</span><span class="o">=</span><span class="mi">6</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
            6  &#39;eee&#39;                 &#39;666-6666&#39;
</pre></div>
</div>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl1</span> <span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">id</span><span class="o">=</span><span class="mi">7</span> <span class="k">ON</span> <span class="n">DUPLICATE</span> <span class="k">KEY</span> <span class="k">UPDATE</span> <span class="n">name</span><span class="o">=</span><span class="s1">&#39;ggg&#39;</span><span class="p">;</span>
<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">id</span><span class="o">=</span><span class="mi">7</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
            7  &#39;ggg&#39;                 &#39;777-7777&#39;
</pre></div>
</div>
<p>In <strong>INSERT ... SET</strong> syntax, the evaluation of an assignment expression is performed from left to right. If the column value is not specified, then the default value is assigned. If there is no default value, <strong>NULL</strong> is assigned.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">tbl</span> <span class="p">(</span><span class="n">a</span> <span class="nb">INT</span><span class="p">,</span> <span class="n">b</span> <span class="nb">INT</span><span class="p">,</span> <span class="k">c</span> <span class="nb">INT</span><span class="p">);</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">tbl</span> <span class="k">SET</span> <span class="n">a</span><span class="o">=</span><span class="mi">1</span><span class="p">,</span> <span class="n">b</span><span class="o">=</span><span class="n">a</span><span class="o">+</span><span class="mi">1</span><span class="p">,</span> <span class="k">c</span><span class="o">=</span><span class="n">b</span><span class="o">+</span><span class="mi">2</span><span class="p">;</span>
<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">tbl</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>        a            b            c
===================================
        1            2            4
</pre></div>
</div>
<p>In the above example, b's value will be 2 and c's value will be 4 since a's value is 1.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">tbl2</span> <span class="p">(</span><span class="n">a</span> <span class="nb">INT</span><span class="p">,</span> <span class="n">b</span> <span class="nb">INT</span><span class="p">,</span> <span class="k">c</span> <span class="nb">INT</span><span class="p">);</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">tbl2</span> <span class="k">SET</span> <span class="n">a</span><span class="o">=</span><span class="n">b</span><span class="o">+</span><span class="mi">1</span><span class="p">,</span> <span class="n">b</span><span class="o">=</span><span class="mi">1</span><span class="p">,</span> <span class="k">c</span><span class="o">=</span><span class="n">b</span><span class="o">+</span><span class="mi">2</span><span class="p">;</span>
</pre></div>
</div>
<p>In the above example, a's value will be <strong>NULL</strong> since b's value is not specified yet when assigning a's value.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">tbl2</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>        a            b            c
===================================
     NULL            1            3
</pre></div>
</div>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">tbl3</span> <span class="p">(</span><span class="n">a</span> <span class="nb">INT</span><span class="p">,</span> <span class="n">b</span> <span class="nb">INT</span> <span class="k">default</span> <span class="mi">10</span><span class="p">,</span> <span class="k">c</span> <span class="nb">INT</span><span class="p">);</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">tbl3</span> <span class="k">SET</span> <span class="n">a</span><span class="o">=</span><span class="n">b</span><span class="o">+</span><span class="mi">1</span><span class="p">,</span> <span class="n">b</span><span class="o">=</span><span class="mi">1</span><span class="p">,</span> <span class="k">c</span><span class="o">=</span><span class="n">b</span><span class="o">+</span><span class="mi">2</span><span class="p">;</span>
</pre></div>
</div>
<p>In the above example, a's value will be 11 since b's value is not specified yet and b's default is 10.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">tbl3</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>        a            b            c
===================================
       11            1            3
</pre></div>
</div>
<div class="section" id="insert-select-statement">
<h2>INSERT ... SELECT Statement<a class="headerlink" href="#insert-select-statement" title="Permalink to this headline">¶</a></h2>
<p>If you use the <strong>SELECT</strong> query in the <strong>INSERT</strong> statement, you can insert query results which satisfy the specified retrieval condition from one or many tables to the target table.</p>
<div class="highlight-python"><div class="highlight"><pre>INSERT [INTO] table_name [(column_name, ...)]
    SELECT...
    [ON DUPLICATE KEY UPDATE column_name = expr, ... ]
</pre></div>
</div>
<p>The <strong>SELECT</strong> statement can be used in place of the <strong>VALUES</strong> keyword, or be included as a subquery in the column value list next to <strong>VALUES</strong>. If you specify the <strong>SELECT</strong> statement in place of the <strong>VALUES</strong> keyword, you can insert multiple query result records into the column of the table at once. However, there should be only one query result record if the <strong>SELECT</strong> statement is specified in the column value list.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="c1">--creating an empty table which schema replicated from a_tbl1</span>
<span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">a_tbl2</span> <span class="k">LIKE</span> <span class="n">a_tbl1</span><span class="p">;</span>

<span class="c1">--inserting multiple rows from SELECT query results</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl2</span> <span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">id</span> <span class="k">IS</span> <span class="k">NOT</span> <span class="k">NULL</span><span class="p">;</span>

<span class="c1">--inserting column value with SELECT subquery specified in the value list</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl2</span> <span class="k">VALUES</span><span class="p">(</span><span class="mi">8</span><span class="p">,</span> <span class="k">SELECT</span> <span class="n">name</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">name</span> <span class="o">&lt;</span><span class="s1">&#39;bbb&#39;</span><span class="p">,</span> <span class="k">DEFAULT</span><span class="p">);</span>

<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl2</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
            1  &#39;aaa&#39;                 &#39;000-0000&#39;
            2  &#39;bbb&#39;                 &#39;000-0000&#39;
            3  &#39;ccc&#39;                 &#39;333-3333&#39;
            4  NULL                  &#39;000-0000&#39;
            5  NULL                  &#39;000-0000&#39;
            6  &#39;eee&#39;                 &#39;000-0000&#39;
            7  NULL                  &#39;777-7777&#39;
            8  &#39;aaa&#39;                 &#39;000-0000&#39;
</pre></div>
</div>
</div>
<div class="section" id="on-duplicate-key-update-clause">
<h2>ON DUPLICATE KEY UPDATE Clause<a class="headerlink" href="#on-duplicate-key-update-clause" title="Permalink to this headline">¶</a></h2>
<p>In a situation in which a duplicate value is inserted into a column for which the <strong>UNIQUE</strong> index or the <strong>PRIMARY KEY</strong> constraint has been set, you can update to a new value by specifying the <strong>ON DUPLICATE KEY UPDATE</strong> clause in the <strong>INSERT</strong> statement.</p>
<div class="admonition note">
<p class="first admonition-title">Note</p>
<ul class="last simple">
<li>If <strong>PRIMARY KEY</strong> and <strong>UNIQUE</strong> or multiple <strong>UNIQUE</strong> constraints exist on a table together, constraint violation can happen by one of them; so in this case, <strong>ON DUPLICATE KEY UPDATE</strong> clause is not recommended.</li>
<li>Even if <strong>UPDATE</strong> is executed after failing executing <strong>INSERT</strong>, <strong>AUTO_INCREMENT</strong> value which is increased once cannot be rolled back into the previous value.</li>
</ul>
</div>
<div class="highlight-python"><div class="highlight"><pre>&lt;INSERT ... VALUES statement&gt;
&lt;INSERT ... SET statement&gt;
&lt;INSERT ... SELECT statement&gt;
    INSERT ...
    [ON DUPLICATE KEY UPDATE column_name = expr, ... ]
</pre></div>
</div>
<ul class="simple">
<li><em>column_name</em> = <em>expr</em>: Specifies the name of the column whose value you want to change next to <strong>ON DUPLICATE KEY UPDATE</strong> and a new column value by using the equal sign.</li>
</ul>
<div class="highlight-sql"><div class="highlight"><pre><span class="c1">--creating a new table having the same schema as a_tbl1</span>
<span class="k">CREATE</span> <span class="k">TABLE</span> <span class="n">a_tbl3</span> <span class="k">LIKE</span> <span class="n">a_tbl1</span><span class="p">;</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl3</span> <span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl1</span> <span class="k">WHERE</span> <span class="n">id</span> <span class="k">IS</span> <span class="k">NOT</span> <span class="k">NULL</span> <span class="k">and</span> <span class="n">name</span> <span class="k">IS</span> <span class="k">NOT</span> <span class="k">NULL</span><span class="p">;</span>
<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl3</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
            1  &#39;aaa&#39;                 &#39;000-0000&#39;
            2  &#39;bbb&#39;                 &#39;000-0000&#39;
            3  &#39;ccc&#39;                 &#39;333-3333&#39;
            6  &#39;eee&#39;                 &#39;000-0000&#39;
</pre></div>
</div>
<div class="highlight-sql"><div class="highlight"><pre><span class="c1">--insert duplicated value violating UNIQUE constraint</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl3</span> <span class="k">VALUES</span><span class="p">(</span><span class="mi">2</span><span class="p">,</span> <span class="s1">&#39;bbb&#39;</span><span class="p">,</span> <span class="s1">&#39;222-2222&#39;</span><span class="p">);</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>ERROR: Operation would have caused one or more unique constraint violations.
</pre></div>
</div>
<p>With ON DUPLICATE KEY UPDATE, &quot;affected rows&quot; value per row will be 1 if a new row is inserted, and 2 if an existing row is updated.</p>
<div class="highlight-sql"><div class="highlight"><pre><span class="c1">--insert duplicated value with specifying ON DUPLICATED KEY UPDATE clause</span>
<span class="k">INSERT</span> <span class="k">INTO</span> <span class="n">a_tbl3</span> <span class="k">VALUES</span><span class="p">(</span><span class="mi">2</span><span class="p">,</span> <span class="s1">&#39;ggg&#39;</span><span class="p">,</span> <span class="s1">&#39;222-2222&#39;</span><span class="p">)</span>
<span class="k">ON</span> <span class="n">DUPLICATE</span> <span class="k">KEY</span> <span class="k">UPDATE</span> <span class="n">name</span><span class="o">=</span><span class="s1">&#39;ggg&#39;</span><span class="p">,</span> <span class="n">phone</span> <span class="o">=</span> <span class="s1">&#39;222-2222&#39;</span><span class="p">;</span>

<span class="k">SELECT</span> <span class="o">*</span> <span class="k">FROM</span> <span class="n">a_tbl3</span> <span class="k">WHERE</span> <span class="n">id</span><span class="o">=</span><span class="mi">2</span><span class="p">;</span>
</pre></div>
</div>
<div class="highlight-python"><div class="highlight"><pre>           id  name                  phone
=========================================================
            2  &#39;ggg&#39;                 &#39;222-2222&#39;

2 rows affected.
</pre></div>
</div>
</div>
</div>


          </div>
        </div>
      </div>
    <div class="sphinxsidebar">
        <div class="sphinxsidebarwrapper">
              <h3><a href="../../index.html">Table Of Contents</a></h3>
              <ul class="current">
<li class="toctree-l1"><a class="reference internal" href="../../toc.html">Introduction to Manual</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../intro.html">Introduction to CUBRID</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../install_upgrade.html">Installing and Upgrading</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../start.html">Getting Started</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../csql.html">CSQL Interpreter</a></li>
<li class="toctree-l1 current"><a class="reference internal" href="../index.html">CUBRID SQL Guide</a><ul class="current">
<li class="toctree-l2"><a class="reference internal" href="../identifier.html">Identifier</a></li>
<li class="toctree-l2"><a class="reference internal" href="../keyword.html">Reserved Words</a></li>
<li class="toctree-l2"><a class="reference internal" href="../comment.html">Comment</a></li>
<li class="toctree-l2"><a class="reference internal" href="../datatype.html">Data Types</a></li>
<li class="toctree-l2"><a class="reference internal" href="../schema/table.html">Table</a></li>
<li class="toctree-l2"><a class="reference internal" href="../schema/index.html">Index</a></li>
<li class="toctree-l2"><a class="reference internal" href="../schema/view.html">View</a></li>
<li class="toctree-l2"><a class="reference internal" href="../schema/serial.html">Serial</a></li>
<li class="toctree-l2"><a class="reference internal" href="../authorization.html">Database User Authorization</a></li>
<li class="toctree-l2"><a class="reference internal" href="../function/index.html">Operators and Functions</a></li>
<li class="toctree-l2 current"><a class="reference internal" href="index.html">Data Manipulation</a><ul class="current">
<li class="toctree-l3"><a class="reference internal" href="select.html">SELECT</a></li>
<li class="toctree-l3"><a class="reference internal" href="hq.html">Hierarchical Query</a></li>
<li class="toctree-l3 current"><a class="current reference internal" href="">INSERT</a></li>
<li class="toctree-l3"><a class="reference internal" href="update.html">UPDATE</a></li>
<li class="toctree-l3"><a class="reference internal" href="replace.html">REPLACE</a></li>
<li class="toctree-l3"><a class="reference internal" href="delete.html">DELETE</a></li>
<li class="toctree-l3"><a class="reference internal" href="merge.html">MERGE</a></li>
<li class="toctree-l3"><a class="reference internal" href="truncate.html">TRUNCATE</a></li>
<li class="toctree-l3"><a class="reference internal" href="prepare.html">PREPARED STATEMENT</a></li>
<li class="toctree-l3"><a class="reference internal" href="prepare.html#set">SET</a></li>
<li class="toctree-l3"><a class="reference internal" href="prepare.html#do">DO</a></li>
<li class="toctree-l3"><a class="reference internal" href="show.html">SHOW</a></li>
</ul>
</li>
<li class="toctree-l2"><a class="reference internal" href="../tuning.html">Query Optimization</a></li>
<li class="toctree-l2"><a class="reference internal" href="../partition.html">Partitioning</a></li>
<li class="toctree-l2"><a class="reference internal" href="../i18n.html">Globalization</a></li>
<li class="toctree-l2"><a class="reference internal" href="../transaction.html">Transaction and Lock</a></li>
<li class="toctree-l2"><a class="reference internal" href="../trigger.html">Trigger</a></li>
<li class="toctree-l2"><a class="reference internal" href="../jsp.html">Java Stored Function/Procedure</a></li>
<li class="toctree-l2"><a class="reference internal" href="../method.html">Method</a></li>
<li class="toctree-l2"><a class="reference internal" href="../oodb.html">Class Inheritance</a></li>
<li class="toctree-l2"><a class="reference internal" href="../catalog.html">System Catalog</a></li>
</ul>
</li>
<li class="toctree-l1"><a class="reference internal" href="../../admin/index.html">Administrator's Guide</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../ha.html">CUBRID HA</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../shard.html">CUBRID SHARD</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../api/index.html">API Reference</a></li>
<li class="toctree-l1"><a class="reference internal" href="../../release_note/index.html">Release Notes</a></li>
</ul>

  <h4>Previous topic</h4>
  <p class="topless"><a href="hq.html"
                        title="previous chapter">Hierarchical Query</a></p>
  <h4>Next topic</h4>
  <p class="topless"><a href="update.html"
                        title="next chapter">UPDATE</a></p>
  <h3>This Page</h3>
  <ul class="this-page-menu">
    <li><a href="../../_sources/sql/query/insert.txt"
           rel="nofollow">Show Source</a></li>
  </ul>
          <h3 style="margin-top: 1.5em;">Manual Search</h3>
          <form class="search" action="../../search.html" method="get">
            <input type="text" name="q" size="18" />
            <input type="submit" value="Go" />
            <input type="hidden" name="check_keywords" value="yes" />
            <input type="hidden" name="area" value="default" />
          </form>
          <p class="searchtip" style="font-size: 90%">
            Search Area: Manual. Enter only one keyword.
          </p>

          <h3 style="margin-top: 1.5em;">Site Search</h3>
          <form class="search" action="http://www.cubrid.org/?" method="get">
            <input type="text" name="is_keyword" size="18" />
            <input type="submit" value="Go" />
            <input type="hidden" name="act" value="IS" />
            <input type="hidden" name="search_target" value="title_content" />
          </form>
          <p class="searchtip" style="font-size: 90%">
            Search Area: cubrid.org Site. You can enter several keywords.
          </p>
       </div> 
    </div>
  
      <div class="clearer"></div>
    </div>
    <div class="related">
      <h3>Navigation</h3>
      <ul>
        <li class="right" style="margin-right: 10px">
          <a href="../../genindex.html" title="General Index"
             >index</a></li>
        <li class="right" >
          <a href="update.html" title="UPDATE"
             >next</a> |</li>
        <li class="right" >
          <a href="hq.html" title="Hierarchical Query"
             >previous</a> |</li>
        <li><a href="../../index.html">CUBRID 9.3.0 documentation</a> &raquo;</li>
          <li><a href="../index.html" >CUBRID SQL Guide</a> &raquo;</li>
          <li><a href="index.html" >Data Manipulation</a> &raquo;</li> 
      </ul>
    </div>
    <div class="footer">
        &copy; Copyright 2014, Search Solution Corporation.
      Last updated on Sep 17, 2015.
      Created using <a href="http://sphinx-doc.org/">Sphinx</a> 1.2.2.
    </div>
  </body>
</html>
', sysdate ) ;
drop table covbr;
