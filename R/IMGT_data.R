call.IMGT.settings.script <- function(imgt.settings.location) {
    # calls the IMGT settings script to generate output files for 'get.IMGT.settings'
    script.location <- system.file("shiny", "shiny_server", 
                        "extra_IMGT_template_options.py", package = "openPrimeRui")
    # args: phantomjs, out-folder
    phantomjs.loc <- Sys.which("phantomjs")
    if (phantomjs.loc == "") {
        stop("PhantomJS not available.")
    }
    args <- paste(normalizePath(phantomjs.loc), imgt.settings.location, sep = " ")
    call <- paste(script.location, " ", args, sep = "")
    #message(call)
    # store all IMGT field options in text files
    system(call, ignore.stdout = TRUE)  
}
get.IMGT.settings <- function() {
    # use a python script to retrieve possible IMGT input options for shiny frontend
    # options are stored in files and are read into R
    imgt.settings.location <- system.file("extdata", "IMGT_options",
                                          package = "openPrimeR")
    if (!dir.exists(imgt.settings.location)) {
        # only retrieve options from IMGT when they aren't available yet
        dir.create(imgt.settings.location)
        call.IMGT.settings.script(imgt.settings.location)
    }
    # retrieve data from files
    files <- list.files(imgt.settings.location)
    options <- vector("list", length(files))
    names(options) <- files
    for (i in seq_along(files)) {
        f <- file.path(imgt.settings.location, files[i])
        data <- readLines(f)
        options[[i]] <- data
    }
    return(options)
}

retrieve.IMGT.templates <- function(species, locus, func, refresh, rm.partials = FALSE) {
    # species, locus, function: parameters for IMGT data retrieval refresh:
    # TRUE/FALSE -> should data be retrieved (TRUE) or should stored data be used if
    # available (FALSE)
    # data sets for which we have novel sequences not in IMGT
    new.data.sets <- c("IGH")
    new.data.available <- species == "Homo sapiens" && locus %in% new.data.sets && func == "functional"
    if (new.data.available) {
        # there's new data available -> load these data from package data
        fname.leader <- get.IMGT.fname(species, locus, func, "leader_exp")
        fname.exon <- get.IMGT.fname(species, locus, func, "exon_exp")
        ret <- c(fname.exon, fname.leader)
        if (!all(file.exists(ret))) {
            warning("File did not exist: ", paste0(ret, collapse = ","))
        }
        return(ret)
    } else {
        fname.leader <- get.IMGT.fname(species, locus, func, "leader")
        fname.exon <- get.IMGT.fname(species, locus, func, "exon")
    }
    ret <- c(fname.exon, fname.leader)
    existing.files <- file.exists(ret)
    if (all(existing.files) && !refresh) {
        # don't recompute if results are already available.
        return(ret)
    }
    imgt.script <- system.file("shiny", "shiny_server", 
                    "extra_IMGT_template_set_extractor.py", 
                    package = "openPrimeRui")
    if (Sys.which("phantomjs") == "") {
        warning("PhantomJS is not in your path. Please install it.")
        return(NULL)
    }
    if (!openPrimeR:::selenium.installed()) {
        warning("Selenium for Python is not available. Please install it.")
        return(NULL)
    }
    base.opts <- paste(normalizePath(Sys.which("phantomjs")), fname.leader, 
        fname.exon, sep = " ")
    input.opts <- paste(paste("\"", species, "\"", sep = ""), paste("\"", locus, 
        "\"", sep = ""), paste("\"", func, "\"", sep = ""), sep = " ")
    cmd <- paste(imgt.script, base.opts, input.opts, sep = " ")
    #print(cmd)
    # warning(cmd) # printout for shiny-server (docker)
    status <- system(cmd, ignore.stdout = TRUE)
    if (status != 0) {
        warning("Failed to retrieve templates from IMGT for unknown reason.")
        return(NULL)
    } else {
        return(ret)
    }
}

get.IMGT.fname <- function(species, locus, func, type) {
    # species, locus, func: args for IMGT db retrieval type: leader or exon replace
    # gaps with underscores for fnames
    species <- gsub(" ", "_", species)
    locus <- gsub(" ", "_", locus)
    func <- gsub(" ", "_", func)
    types <- c("leader", "exon")
    template.folder <- system.file("extdata", "IMGT_data", "templates",
                        package = "openPrimeR")
    names <- file.path(template.folder, paste(species, "_", locus, "_", func, 
        "_", type, ".fasta", sep = ""))
    return(names)
}

primer.set.choices <- function(primers) {
    if (length(primers) == 0) {
        return(NULL)
    }
    paths <- primers
    locus <- strsplit(primers[1], split = "/")[[1]]
    locus <- locus[length(locus) - 1]
    # get basenames
    primers <- basename(primers)
    # remove 'IPS' annotation
    idx <- grep("IPS", primers)
    mod <- unlist(lapply(strsplit(primers[idx], split = "_"), function(x) x[[2]]))
    primers[idx] <- mod
    # remove extension
    primers <- sub("^([^.]*).*", "\\1", primers)
    # remove name of locus from set name
    idx <- grep(locus, primers)
    mod <- sub(paste("_", locus, sep = ""), "", primers[idx])
    primers[idx] <- mod
    o <- order(primers)  # order by author
    primers <- primers[o]
    paths <- paths[o]  # order paths also ..
    names(paths) <- primers
    return(paths)
}

get.supplied.comparison.template.path <- function(locus) {
    # loads locally stored csv containing template analysis results
    if (length(locus) == 0 || locus == "") {
        return(NULL)
    }
    fname <- paste(locus, "_templates.csv", sep = "")
    load.path <- system.file("extdata", "IMGT_data", "comparison", "templates", 
                 fname, package = "openPrimeR")
    if (!file.exists(load.path)) {
        warning(paste("Template comparison data for ", locus, " not found! Specified comparison path was: ", 
            load.path, sep = ""))
        return(NULL)
    }
    res <- list(datapath = load.path, name = locus)
    return(res)
}

comparison.primer.choices <- function(locus) {
    if (length(locus) == 0) {
        return(NULL)
    }
    path <- system.file("extdata", "IMGT_data", "comparison",
                        "primer_sets", package = "openPrimeR")
    path <- file.path(path, locus)
    if (!dir.exists(path)) {
        warning(paste("Primer comparison folder ", path, " not found!", sep = ""))
        return(NULL)
    }
    fnames <- list.files(path, pattern = "*.csv", full.names = TRUE)
    primers <- basename(fnames)
    # remove 'IPS' annotation
    idx <- grep("IPS", primers)
    mod <- unlist(lapply(strsplit(primers[idx], split = "_"), function(x) x[[3]]))
    primers[idx] <- mod
    # remove extension
    primers <- gsub("^([^.]*).*", "\\1", primers)
    # remove name of locus from set name
    idx <- grep(locus, primers)
    mod <- sapply(strsplit(primers[idx], split = "_"), function(x) paste(x[!grepl(locus, 
        x)], collapse = "_"))
    primers[idx] <- mod
    o <- order(primers)  # order by author
    out <- fnames[o]
    names(out) <- primers[o]
    return(out)
}

