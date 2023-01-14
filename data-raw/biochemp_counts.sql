SELECT
   ev.collector_event_id Consecutive,
   ev.collector_event_id || '_' || ph.collector_sample_id sample_id,
   pg.split_fraction,
   ntc.taxonomic_name,
   lh.name stage,
   lh.molt_number,
   sx.name sex,
   ph.mesh_size,
   pg.counts
FROM
   biochem.bcevents ev,
   biochem.bclifehistories lh,
   biochem.bcnatnltaxoncodes ntc,
   biochem.bcplanktngenerals pg,
   biochem.bcplanktnhedrs ph,
   biochem.bcsexes sx,
   (SELECT "sample_id" FROM TMP) tmp
WHERE
   ev.event_seq = ph.event_seq
   AND lh.life_history_seq = pg.life_history_seq
   AND ntc.national_taxonomic_seq = pg.national_taxonomic_seq
   AND ph.plankton_seq = pg.plankton_seq
   AND sx.sex_seq = pg.sex_seq
   AND pg.counts IS NOT NULL
   AND ev.collector_event_id || '_' || ph.collector_sample_id = tmp."sample_id"
ORDER BY
   ph.start_date,
   ph.start_time,
   ntc.taxonomic_name