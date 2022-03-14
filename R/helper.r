##' replace levels
##' @param x string with values to replace
##' @param a string with unique old values
##' @param b string with unique new levels
##' @details Used to replace cryptic numbers in data by meaningful character strings.
##' @rdname repl
repl <- function(x,a,b){
    x <- as.factor(x)
    l <- as.list(a)
    names(l) <- b
    levels(x) <- l
    return(x)
}
