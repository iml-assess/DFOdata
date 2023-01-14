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
##' @param arguments subset for columns
##' @rdname sql.where
sql.where <- function(table,column,arguments){
    i <- column[duplicated(column)]
    if(length(i)>0){
        links <- sapply(i, function(j){
            paste(
                paste(
                    table[which(column %in% j)],
                    j,
                    sep='.'),
                collapse = " = ")
        })
        s <- paste("where ",paste(links,collapse = ' AND '))
    }else{
        s <- NULL
    }
    if(!missing(arguments)){
        i <- arguments[arguments!=""]
        if(length(i)>0){
            args <- sapply(i, function(j){
                paste(
                    paste(
                        table[which(arguments %in% j)],
                        column[which(arguments %in% j)],
                        sep='.'),
                    j)
            })
            sep <- ifelse(is.null(s),'',' AND ')
            a <- paste0(sep,paste(args,collapse = ' AND '))
            s <- paste0(s,a)
        }
    }
    return(s)
}

##' create sql query
##' @param table full table names (without species)
##' @param table_short short table names
##' @param column column names
##' @param species species name (see avail.species function)
##' @rdname sql.query
sql.query <- function(table, column, species, arguments){
    select <- sql.select(table,column)
    from <- sql.from(table,species)
    where <- sql.where(table,column,arguments)
    ret <- paste(select,from,sep='\n  ')
    if(!is.null(where)) ret <- paste(ret,where,sep='\n  ')
    return(ret)
}
