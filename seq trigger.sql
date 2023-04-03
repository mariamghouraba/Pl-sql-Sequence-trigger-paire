set serveroutput on
DECLARE 
 cursor seq_cursor is
SELECT cols.table_name as table_name , cols.column_name as column_name
FROM user_constraints cons, user_cons_columns cols
WHERE cons.constraint_type = 'P'
AND cons.constraint_name = cols.constraint_name
AND COLS.TABLE_NAME<>'JOBS'
AND COLS.TABLE_NAME<>'COUNTRIES'
AND COLS.TABLE_NAME<>'RETIRED_EMPLOYYEES'
AND COLS.TABLE_NAME<>'JOB_HISTORY';

--var number (10);
cnt number(10);
my_seq varchar2(1000);
my_max varchar2(1000);
max_id number(10);
--valu_max number(10);
my_trig varchar2(1000);

BEGIN 

   for x in seq_cursor loop
      
    my_max :='select max(' ||x.column_name || ')  from '|| x.table_name;
    EXECUTE IMMEDIATE my_max into max_id ;
       -- valu_max :=to_number(max_id);
        If max_id is Null Then
            max_id := 0;
         End if ;
       --execute immediate 'select MAX (' || x.column_name || ')+1  into max_id from '|| x.owner|| '.'|| x.table_name;
        my_seq := 'seq'||x.table_name||'_';
         my_trig := 'trig'||x.table_name||'_' ;
       /* select sequence_name,count(*) into my_seq,cnt from user_sequences where sequence_name in
         (select sequence_name from user_sequences where sequence_name ='hr.sequence_name')
         group by sequence_name; */
        select count(*) 
        into cnt 
        from user_objects 
        where object_type='SEQUENCE' and 
        object_name=upper(my_seq);
 
       if cnt = 1 then 
            execute immediate 'drop sequence '||my_seq ;
       end if;

  --  DBMS_OUTPUT.PUT_LINE ( 'create sequence '||my_seq||' start with '||to_char( max_id+1)||' increment by 10' ) ; 
    
       
   execute immediate 'create sequence '||my_seq||' start with '||to_char( max_id+1)||' increment by 10';
   execute immediate  'create or replace trigger '||my_trig||' 
  before insert 
  on '||x.table_name||' 
  for each row 
  begin 
        :new.'||x.column_name||' := '||my_seq||'.nextval;
    end;';

        end loop;  
        
 end;  
 
 
 show errors; 
 
 
  

insert into sandora (last_name , salary) values('Mariemm' , 1000) ;
Insert into departments (department_name) values ('Mariemmnew' ) ;
