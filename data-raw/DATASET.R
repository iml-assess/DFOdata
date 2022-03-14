## All read functions require additional data, which is stored in raw csv files; 
# - key: positions of fixed width columns
# - other: transform codes into their values (e.g. species code to species name, engin code to engin name)

# load all raw data
raw  <- list.files('data-raw' , pattern = 'csv', full.names = T)
rawn <- sub('\\.csv$', '',list.files('data-raw' , pattern = 'csv'))

rawcsv <- lapply(raw, read.csv)
names(rawcsv) <- rawn
list2env(rawcsv,envir=.GlobalEnv)

# save for use in package
usethis::use_data(odbc_data_selection,
                  odbc_tables,
                  pecpro_gear,
                  pecpro_length.bin,
                  pecpro_length.type,
                  pecpro_prov,
                  pecpro_sample.cat,
                  pecpro_source,
                  pecpro_state.id,
                  internal = TRUE, overwrite = TRUE)


