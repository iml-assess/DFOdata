##' function to extract data fom odbc databases
##' @param query sql query to extract data
##' @param database name of the database (see avail.database function)
##' @param user user name to connect to database
##' @param password password to connect to database
##' @details connect, extract, close
##' @import odbc DBI
##' @rdname bridge.odbc
bridge.odbc <- function(query,database,user,password){
    # connect with database
    con <- odbc::dbConnect(odbc::odbc(), database, UID=user, PWD=password)
    # get data
    ret <- odbc::dbGetQuery(con, query)
    # disconnect
    DBI::dbDisconnect(con)
    
    return(ret)
}

##' function to get (car)bio data fom odbc databases
##' @param species name of the species (see avail.species function)
##' @param user user name to connect to database
##' @param password password to connect to database
##' @details There are small differences with the SAP extractions (e.g., if sample.id=NA rows are not kept, trivial differences in rounding for length/weight).
##' @import lubridate
##' @rdname get.bio
##' @export
get.bio <- function(species,user,password){
    if(missing(species)) stop ("species is missing")
    if(!species %in% avail.species()) stop(paste("species available:",paste(avail.species(),collapse = ', ')))
    if(missing(user)) stop ("user is missing")
    if(missing(password)) stop ("password is missing")
    
    # make query
    sel <- odbc_data_selection[odbc_data_selection$data=='bio',]
    this.query <- with(sel, sql.query(table, column, species))
    
    # extract data
    d <- bridge.odbc(this.query,database='IMLP',user=user,password=password)
    names(d) <- sel$R                  # new columns names
    d <- d[!duplicated(as.list(d))]    # remove duplicate columns (ids that connect tables)
    
    # Copy the steps from SAP
    d$year <- year(d$date)
    d$month <- month(d$date)
    d$day <- day(d$date)
    d$nafo <-substr(d$nafo.sub,1,2)
    
    # add additional columns
    d <- merge(d, pecpro_gear[,1:2], all.x = TRUE, by = 'gear') # gear_full
    d$source.full <- repl(d$source,pecpro_source$source,pecpro_source$source.full)
    
    # replace identification numbers by something meaningful
    d$prov <- repl(d$prov,pecpro_prov$prov,pecpro_prov$prov.full)
    d$length.type <- repl(d$length.type,pecpro_length.type$length.type,pecpro_length.type$length.type.full)
    
    # reorder    
    d <- d[order(d$date,d$sample.id,d$length.fresh,d$length.frozen),]
    return(d)
}

##' function to get length-frequency data fom odbc databases
##' @param species name of the species (see avail.species function)
##' @param user user name to connect to database
##' @param password password to connect to database
##' @details  No details
##' @import lubridate
##' @rdname get.lf
##' @export
get.lf <- function(species,user,password){
    if(missing(species)) stop ("species is missing")
    if(!species %in% avail.species()) stop(paste("species available:",paste(avail.species(),collapse = ', ')))
    if(missing(user)) stop ("user is missing")
    if(missing(password)) stop ("password is missing")
    
    # make query
    sel <- odbc_data_selection[odbc_data_selection$data=='lf',]
    this.query <- with(sel, sql.query(table, column, species))
    
    # extract data
    d <- bridge.odbc(this.query, database='IMLP',user=user,password=password)
    names(d) <- sel$R                  # new columns names
    d <- d[!duplicated(as.list(d))]    # remove duplicate columns (ids that connect tables)
    
    # Copy the steps from SAP
    d$year <- year(d$date)
    d$month <- month(d$date)
    d$day <- day(d$date)
    d$nafo <-substr(d$nafo.sub,1,2)
    
    # add additional columns
    d <- merge(d, pecpro_gear[,1:2], all.x = TRUE, by = 'gear') # gear_full

    # replace identification numbers by something meaningful (done in R rather sql so in English and easy tables in csv)
    d$prov <- repl(d$prov,pecpro_prov$prov,pecpro_prov$prov.full)
    d$length.bin <- repl(d$length.bin,pecpro_length.bin$length.bin,pecpro_length.bin$length.bin.full)
    d$length.type <- repl(d$length.type,pecpro_length.type$length.type,pecpro_length.type$length.type.full)
    d$sample.cat <- repl(d$sample.cat,pecpro_sample.cat$sample.cat,pecpro_sample.cat$sample.cat.full)
    d$source.full <- repl(d$source,pecpro_source$source,pecpro_source$source.full)
    d$state.id <- repl(d$state.id,pecpro_state.id$state.id,pecpro_state.id$state.id.full)
    
    # reorder    
    d <- d[order(d$date,d$sample.id,d$length),]
}

##' function to get egg survey data
##' @param user user name to connect to database
##' @param password password to connect to database
##' @param driver character string (default: Oracle in OraClient12Home1)
##' @details The default driver is 'Oracle in OraClient12Home1'. Use argument driver=xxxx to connect with another driver.
##' @import odbc DBI
##' @rdname get.eggs
##' @export
get.eggs <- function(user,password,driver="Oracle in OraClient12Home1"){
    if(missing(user)) stop ("user is missing")
    if(missing(password)) stop ("password is missing")
    
    # extract two data tables
        ## connect with database
        connect.string <- paste0("Driver={",driver,"};Dbq=",database,";Uid=",user,";Pwd=",password,";")
        con <- odbc::dbConnect(odbc::odbc(),.connection_string = connect.string)
        
        ## get station data
        d1 <- odbc::dbGetQuery(con, biochemp_stations)
        names(d1) <- tolower(names(d1))
        
        ## write table
        tf <- odbc::dbExistsTable(con, name="TMP", schema = NULL)
        if(tf) status <- dbRemoveTable(con, name="TMP", purge=TRUE, schema=NULL)
        status <- odbc::dbWriteTable(con, name="TMP", value=d1, row.names=FALSE, overwrite=TRUE,append=FALSE, ora.number=TRUE, schema=NULL)
        
        ## get egg data (based on sample id stations, in previously written file)
        d2 <- odbc::dbGetQuery(con, biochemp_counts)
        names(d2) <- tolower(names(d2))
        
        ## remove table again and disconnect
        status <- dbRemoveTable(con, name="TMP", purge=TRUE, schema=NULL)
        DBI::dbDisconnect(con)
        
    # put together
    attr(d1,'query') <- biochemp_stations
    attr(d2,'query') <- biochemp_counts
    d <- list(stations=d1,counts=d2)
    
    # quality control checks: stations
    ## depths
    index <- d1$start_depth==d1$end_depth
    if (any(index)){
        index <- which(index)
        warning(paste0(length(index), "stations with start depth = end depth. Obvervations removed"))
        d1 <- d1[-index,]
    }
    ## volumes
    index <- is.na(d1$volume)
    if (any(index)){
        index <- which(index)
        warning(paste0(length(index), "stations where volume=NA"))
    }
    
    # quality control checks: counts
    ## split fraction
    index <- d2$split_fraction==0 | is.na(d2$split_fraction)
    if (any(index)) {
        index <- which(index)
        warning(paste0(length(index), "sample counts with split fraction 0 or NA"))
        d2 <- d2[-index,]
    }
    
    return(d)
}
