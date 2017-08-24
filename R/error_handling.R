#' Error/Warning Handler.
#'
#' Evaluates an expression without throwing warning/errors.
#'
#' Instead of throwing warnings/errors, the warnings/errors are
#' returned in a list object, alongside with the results.
#' 
#' @param expr Expression to evaluate
#' @return List containing values, warnings, and errors.
#' @keywords internal
withWarnings <- function(expr) {
    # call a function and store all warning in a list item "warnings". if we used tryCatch, execution would stop in case of warnings which we don't want
    myWarnings <- NULL
    myErrors <- NULL
    res <- withCallingHandlers(tryCatch(expr, error = function(e) {
      myErrors <<- append(myErrors, list(e))
      NULL
    }), warning = function(w) {
      myWarnings <<- append(myWarnings, list(w))
      invokeRestart("muffleWarning")
    })
	return(list(value = res, warnings = myWarnings, errors = myErrors))
} 
#' Custom Catch Function
#'
#' Returns a data frame if the input expression causes an error, 
#' otherwise returns the value of the evaluated expression.
#' 
#' @param expr Expression to evaluate.
#'
#' @return The evaluated expression.
#' @keywords internal
myCatch <- function(expr) {
    data <- try(expr())
    if (class(data)[1] == "try-error") {
        return(data.frame())
    } else {
        return(expr)
    }
}
 
