
select 
last_call_et,
-- days added to hours
--( trunc(LAST_CALL_ET/86400) * 24 ) || ':' ||
-- days separately
substr('0'||trunc(LAST_CALL_ET/86400),-2,2) || ':' ||
-- hours
substr('0'||trunc(mod(LAST_CALL_ET,86400)/3600),-2,2) || ':' ||
-- minutes
substr('0'||trunc(mod(mod(LAST_CALL_ET,86400),3600)/60),-2,2) || ':' ||
--seconds
substr('0'||mod(mod(mod(LAST_CALL_ET,86400),3600),60),-2,2) idle_time,
to_date(to_char(s.LAST_ACTIVE_TIME,'DD/MM/YYYY HH24:mi:ss'),'DD/MM/YYYY HH24:mi:ss') LAST_ACTIVE_TIME,
to_date(to_char(sysdate,'DD/MM/YYYY HH24:mi:ss'),'DD/MM/YYYY HH24:mi:ss') ACTUAL_time,
s.SQL_TEXT,
'ALTER SYSTEM KILL SESSION '''||u.sid||','||u.serial#||'''' kill_command,
u.OSUSER,
u.USERNAME,
u.PROGRAM,
u.MACHINE,
u.STATUS,
u.LOGON_TIME,
u.BLOCKING_SESSION_STATUS,
u.BLOCKING_INSTANCE,
u.STATE,
U.BLOCKING_SESSION
from v$session u, v$sql s
where s.SQL_ID = u.SQL_ID
AND STATUS='ACTIVE'
--and s.LAST_ACTIVE_TIME < sysdate
--and last_call_et > sysdate - (sysdate - (60/86400))--60 seconds
AND LAST_CALL_ET > 180 -- 180 SECONDS
AND u.USERNAME <> 'SYS'
order by u.LOGON_TIME
;
