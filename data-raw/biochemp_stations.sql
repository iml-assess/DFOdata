SELECT DISTINCT
   mi.name mission_name,
   ev.collector_event_id Consecutive,
   ev.collector_event_id || '_' || ph.collector_sample_id sample_id,
   ph.COLLECTOR_DEPLOYMENT_ID,
   ev.collector_station_name,
   TO_NUMBER(TO_CHAR(ph.start_date, 'YYYY')) year,
   TO_NUMBER(TO_CHAR(ph.start_date, 'MM')) month,
   TO_NUMBER(TO_CHAR(ph.start_date, 'DD')) day,
   ph.start_time start_time,
   ph.end_time end_time,
   ph.start_lat latitude,
   ph.start_lon longitude,
   ph.start_depth,
   ph.end_depth,
   ph.sounding,
   ph.volume,
   ge.model gear_model,
   ph.mesh_size,
   ph.collector collector_name, 
   ph.collector_comment,
   ph.DATA_MANAGER_COMMENT,
   mi.collector_comment mission_comment1,
   mi.data_manager_comment mission_comment2
 FROM
   biochem.bcdatacenters dc,
   biochem.bcevents ev,
   biochem.bcgears ge,
   biochem.bcmissions mi,
   biochem.bcplanktngenerals pg,
   biochem.bcplanktnhedrs ph
WHERE
   /* link tables */
   ge.gear_seq = ph.gear_seq
   AND ev.event_seq = ph.event_seq
   AND dc.data_center_code = ph.data_center_code
   AND mi.mission_seq = ev.mission_seq
   AND ph.plankton_seq = pg.plankton_seq
    /* data filter */
   AND UPPER(ge.model) LIKE '%BONGO%'
   AND ph.mesh_size >300
  AND ((upper(mi.name) LIKE '%MAQ%' AND mi.name NOT LIKE '%international%') 
OR mi.name LIKE '%Prince%' OR upper(mi.name) LIKE '%ECOSYS%' OR mi.name LIKE '%Mac%' OR upper(mi.name) LIKE '%AZMP%' OR upper(mi.name) LIKE '%PMZA%')
AND mi.name NOT LIKE '%Baie%'
AND mi.name NOT LIKE '%George%'
AND mi.name NOT LIKE '%acoustique%'
AND (TO_CHAR(mi.start_date,'MM') = 6 OR TO_CHAR(mi.start_date,'MM') = 5)
ORDER BY
   year,
   month,
   day,
   start_time