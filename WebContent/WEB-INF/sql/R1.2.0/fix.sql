/**
 * Esto debe ser ejecutado antes del run-once de esta version 
 * para eliminar la informacion duplicada de la base de datos.
 * 
 */

delete from treportoutvalue where cparam >4;
delete from tReportOutParam  where cid>4;

delete from treportoutvalue where creport>=9;
delete from tReport where cid>=9;
delete from tReportOutType where cid>4;

delete from tReportParamType where cid>=6;
