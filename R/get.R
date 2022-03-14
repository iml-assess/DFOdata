##' function to extract data fom odbc databases
##' @param data data to extract (see avail.data function)
##' @param database name of the database (see avail.database function)
##' @param species name of the species (see avail.species function)
##' @param user user name to connect to database
##' @param password password to connect to database
##' @details workhorse function that will do the extracting
##' @import odbc DBI
##' @rdname bridge.odbc
bridge.odbc <- function(data,database,species,user,password){
    sel <- odbc_data_selection[odbc_data_selection$data==data,]
    this.query <- with(sel, sql.query(table, column, species))

    con <- odbc::dbConnect(odbc::odbc(), "IMLP", UID=user, PWD=password)
    ret <- odbc::dbGetQuery(con, this.query)
    names(ret) <- sel$R
    ret <- ret[!duplicated(as.list(ret))] # remove duplicate columns (ids that connect tables)
    
    return(ret)
}

##' function to get (car)bio data fom odbc databases
##' @param species name of the species (see avail.species function)
##' @param user user name to connect to database
##' @param password password to connect to database
##' @details There are small differences with the SAP extractions (e.g., if sample.id=NA rows are not kept, trivial differences in rounding for length/weight)
##' @import lubridate
##' @rdname get.bio
##' @export
get.bio <- function(species,user,password){
    if(missing(species)) stop ("species is missing")
    if(!species %in% avail.species()) stop(paste("species available:",paste(avail.species(),collapse = ', ')))
    if(missing(user)) stop ("user is missing")
    if(missing(password)) stop ("password is missing")
    
    d <- bridge.odbc(data='bio',database='pec_pro', species=species,user=user,password=password)
    
    # Copy the steps from SAP
    d$year <- year(d$date)
    d$month <- month(d$date)
    d$day <- day(d$date)
    d$nafo <-substr(d$nafo.sub,1,2)
    
    # add additional columns
    d <- merge(d, pecpro_gear[,1:2], all.x = TRUE, by = 'gear') # gear_full
    
    # replace identification numbers by something meaningful
    d$prov <- repl(d$prov,pecpro_prov$prov,pecpro_prov$prov.full)
    
    # reorder    
    d <- d[order(d$date,d$sample.id,d$length),]
    return(d)
}

##' function to get length-frequency data fom odbc databases
##' @param species name of the species (see avail.species function)
##' @param user user name to connect to database
##' @param password password to connect to database
##' @details no details
##' @import lubridate
##' @rdname get.lf
##' @export
get.lf <- function(species,user,password){
    if(missing(species)) stop ("species is missing")
    if(!species %in% avail.species()) stop(paste("species available:",paste(avail.species(),collapse = ', ')))
    if(missing(user)) stop ("user is missing")
    if(missing(password)) stop ("password is missing")
    
    d <- bridge.odbc(data='lf',database='pec_pro', species=species,user=user,password=password)
    
    # Copy the steps from SAP
    d$year <- year(d$date)
    d$month <- month(d$date)
    d$day <- day(d$date)
    d$nafo <-substr(d$nafo.sub,1,2)
    
    # add additional columns
    d <- merge(d, pecpro_gear[,1:2], all.x = TRUE, by = 'gear') # gear_full

    # replace identification numbers by something meaningful
    d$prov <- repl(d$prov,pecpro_prov$prov,pecpro_prov$prov.full)
    d$length.bin <- repl(d$length.bin,pecpro_length.bin$length.bin,pecpro_length.bin$length.bin.full)
    d$length.type <- repl(d$length.type,pecpro_length.type$length.type,pecpro_length.type$length.type.full)
    d$sample.cat <- repl(d$sample.cat,pecpro_sample.cat$sample.cat,pecpro_sample.cat$sample.cat.full)
    d$source <- repl(d$source,pecpro_source$source,pecpro_source$source.full)
    d$state.id <- repl(d$state.id,pecpro_state.id$state.id,pecpro_state.id$state.id.full)
    
    # reorder    
    d <- d[order(d$date,d$sample.id,d$length),]
}







