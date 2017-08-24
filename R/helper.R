change.extension <- function(x, ext) {
    out <- sub("\\.[[:alnum:]]+$", "", x)
    out <- paste(out, ".", ext, sep = "")
    return(out)
} 

update.sample.name <- function(df, sample.name) {
    # updates the Run column of a data frame
    if (length(df) == 0 || nrow(df) == 0) {
        return(NULL)
    }
    if (length(sample.name) == 0) {
        return(df)
    } else {
        df$Run <- sample.name
    }
    return(df)
}

