get.supplied.comparison.template.path.virus <- function(virus, region) {
    if (length(region) == 0 || region == "") {
        return(NULL)
    }
    path <- system.file("extdata", "Vir", virus, region, "comparison",
                        "templates", package = "openPrimeR")
    csv.file <- list.files(path, full.names = TRUE)[1]
    if (!file.exists(csv.file)) {
        warning(paste0("Template comparison data for ", virus, " and ", region, 
                       ",not found!"))
        return(NULL)
    }
    res <- list(datapath = csv.file, name = region)
    return(res)
}

get.available.viruses <- function() {
    # determine for which viruses there are available template sequences
    virus.folder <- system.file("extdata", "Vir", package = "openPrimeR")
    virs <- basename(list.dirs(virus.folder, recursive = FALSE))
    return(virs)
}


