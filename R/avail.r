##' species names in databases
##' @param database databse in which to look (e.g., pec_pro)
##' @details lists species names in pec_pro. Not all species have all tables available (bio vs commercial samples)
##' @rdname avail.species
##' @export
avail.species <- function(database=NULL){
    if(!is.null(database)) d <- odbc_tables[odbc_tables$database==database,] else d <- odbc_tables
    unique(d$species)
}

##' databases included in package
##' @details lists databases
##' @rdname avail.database
##' @export
avail.database <- function(){
    unique(odbc_data_selection[,c('data','database')])
}

##' available data
##' @details lists available data
##' @rdname avail.data
##' @export
avail.data <- function(){
    unique(odbc_data_selection$data)
}