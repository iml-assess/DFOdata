##' create string with columns to be selected
##' @param table_short short table name
##' @param column column name
##' @rdname sql.select
sql.select <- function(table,column){
    paste("select",
          paste(
              paste(table,column,sep="."),
              collapse = paste0(",", '\n  ')
          ), sep = paste0(" ", '\n  ')
    )
}

##' create string ith table to select from
##' @param table full table names (without species)
##' @param species species name (see avail.species function)
##' @param table_short short table names
##' @rdname sql.from
sql.from <- function(table,species){
    paste0("from ",
           paste(
               paste(
                   paste0(unique(table),species),
                   unique(table),
                   sep=" "),
               collapse = ', ')
    )
}

##' create string for where 
##' @param table_short short table names
##' @param column column names
##' @rdname sql.where
sql.where <- function(table,column){
    i <- column[duplicated(column)]
    if(length(i)>0)
        paste0("where ",
               paste(
                   paste(unique(table),
                         column[duplicated(column)],sep='.'),
                   collapse = " = "
               )
        )else{
            NULL
        }
}

##' create sql query
##' @param table full table names (without species)
##' @param table_short short table names
##' @param column column names
##' @param species species name (see avail.species function)
##' @rdname sql.query
sql.query <- function(table, column, species){
    select <- sql.select(table,column)
    from <- sql.from(table,species)
    where <- sql.where(table,column)
    ret <- paste(select,from,sep='\n  ')
    if(!is.null(where)) ret <- paste(ret,where,sep='\n  ')
    return(ret)
}
