view.input.sequences <- function(template.df) {
    # shiny output after reading template sequences
    if (nrow(template.df) == 0 || length(template.df) == 0) {
        return(NULL)
    }
    template.df <- asS3(template.df) # modifying columns -> type can't be preserved
    excl.col <- c("Header", "Identifier", "Sequence_Length", "Allowed_Start_fw", 
        "Allowed_End_fw", "Allowed_Start_rev", "Allowed_End_rev", 
        "Run", "Allowed_Start_fw_initial", "Allowed_End_fw_initial", 
        "Allowed_Start_rev_initial", "Allowed_End_rev_initial", "InputSequence")
    # add all "ali" columns to exclusion:
    ali.cols <- colnames(template.df)[grep("_ali", colnames(template.df))]
    excl.col <- c(excl.col, ali.cols)
    view.df <- openPrimeR:::exclude.cols(excl.col, template.df)
    # remove all columns where all values are missing
    excl.idx <- which(unlist(lapply(seq_len(ncol(view.df)), function(x) all(view.df[,x] == "" | is.na(view.df[,x]) | view.df[,x] == 
        "NA-NA"))))
    if (length(excl.idx) != 0) {
        view.df <- view.df[, -excl.idx]
    }
    view.df <- openPrimeR:::modify.col.rep(view.df)
    return(view.df)
}

view.template.sequences <- function(template.df) {
    # shiny output after leaders have been assigned
    if (nrow(template.df) == 0 || length(template.df) == 0) {
        return(NULL)
    }
    template.df <- asS3(template.df)
    excl.col <- c() # nothing to exclude here at the moment
    view.df <- openPrimeR:::exclude.cols(excl.col, template.df)
    # show value ranges in dash notation as one column only show if we have some
    # annotated leaders..
    if ("Allowed_Start_fw" %in% colnames(view.df)) {
        if (any(!is.na(template.df$Allowed_Start_fw))) {
            leader.range.fw <- paste0(template.df$Allowed_Start_fw, "-", template.df$Allowed_End_fw)
            view.df$Allowed_Start_fw <- leader.range.fw
        }
    }
    if ("Allowed_Start_rev" %in% colnames(view.df)) {
        if (any(!is.na(template.df$Allowed_Start_rev))) {
            leader.range.rev <- paste0(template.df$Allowed_Start_rev, "-", template.df$Allowed_End_rev)
            view.df$Allowed_Start_rev <- leader.range.rev
        }
    }
    change.cols <- c("Allowed_Start_fw", "Allowed_Start_rev")
    new.names <- c("Allowed Binding Range (fw)", "Allowed Binding Range (rev)")
    for (i in seq_along(change.cols)) {
        colnames(view.df)[colnames(view.df) == change.cols[i]] <- new.names[i]
    }
    view.df <- view.input.sequences(view.df)
    return(view.df)
}

view.mismatch.table <- function(mismatch.table) {
    if (length(mismatch.table) == 0 || nrow(mismatch.table) == 0) {
        return(NULL)
    }
    excl.col <- c("NT_nbr_mm", "AA_nbr_mm", "Seq_NT", "Primer_NT", "Seq_AA", "Primer_AA", 
        "Primer_ID", "Primer_Seq")
    view.df <- openPrimeR:::exclude.cols(excl.col, mismatch.table)
    col.order <- c("Primer", "Template", "Alignment_NT", "Mutation_Type", 
        "Alignment_AA", "Comment")
    view.df <- view.df[, col.order]
    view.df <- openPrimeR:::modify.col.rep(view.df)
    return(view.df)
}
view.cvg.sequences <- function(template.df, primer.df) {
    # viewing templates with annotated coverage
    if (nrow(template.df) == 0 || length(template.df) == 0) {
        return(NULL)
    }
    if (!"primer_coverage" %in% colnames(template.df)) {
        # nothing to change here
        return(view.template.sequences(template.df))
    }
    template.df <- asS3(template.df)
    excl.col <- c() # no columns to exclude
    view.df <- openPrimeR:::exclude.cols(excl.col, template.df)
    # convert from identifier coverage to ID coverage
    cvg.cols <- c("Covered_By_Primers", "Covered_By_Primers_fw", 
                    "Covered_By_Primers_rev")
    for (i in seq_along(cvg.cols)) {
        col <- cvg.cols[i]
        if (col %in% colnames(view.df)) {
            view.df[, col] <- unlist(openPrimeR:::covered.primers.to.ID.string(view.df[, col], primer.df)) 
       }
    }
    # re-order
    col.order <- c("ID", "Group", 
        "primer_coverage", "primer_coverage_fw", 
        "primer_coverage_rev", "Allowed_fw", "Allowed_rev",
        "Allowed_Start_fw", "Allowed_End_fw",
        "Allowed_Start_rev", "Allowed_End_rev",
        "Covered_By_Primers", "Covered_By_Primers_fw",
        "Covered_By_Primers_rev"
        )
    other.cols <- setdiff(colnames(view.df), col.order)  # don't care about these cols in ordering
    view.df <- view.df[, c(col.order, other.cols)]
    # don't order by cvg -> misleading
    #view.df <- view.df[order(view.df$primer_coverage, decreasing = TRUE), ]
    # remove columns of unrelevant direction
    mode.directionality <- openPrimeR:::get.analysis.mode(primer.df)
    # special.cols: redundant for single direction
    special.cols <- c("Covered_By_Primers", "primer_coverage")
    excl <- NULL
    if (mode.directionality == "fw") {
        excl <- grep("_rev", colnames(view.df))
        idx <- which(colnames(view.df) %in% paste0(special.cols, "_fw"))
        excl <- c(excl, idx)
    } else if (mode.directionality == "rev") {
        excl <- grep("_fw", colnames(view.df))
        idx <- which(colnames(view.df) %in% paste0(special.cols, "_rev"))
        excl <- c(excl, idx)
    }
    if (length(excl) != 0) {
        view.df <- view.df[, -excl]
    }
    view.df <- view.template.sequences(view.df)
    return(view.df)
}
view.subset.primers <- function(primer.df, template.df, mode.directionality, view.cvg.individual = "inactive") {
    if (length(primer.df) == 0) {
        return(NULL)
    } else if (nrow(primer.df) == 0) {
        return(primer.df)
    }
    view.df <- asS3(primer.df)
    # convert covered template seqs to group representation
    cvd <- openPrimeR:::covered.seqs.to.ID.string(as.character(view.df$Covered_Seqs), template.df)
    if (length(unique(template.df$Group)) >= 2 && view.cvg.individual == "inactive") {
        # show gene group instead of identifiers
        idx <- openPrimeR:::covered.seqs.to.idx(as.character(view.df$Covered_Seqs), template.df)
        cvd <- openPrimeR:::string.list.format(sapply(seq_along(idx), function(x) paste(template.df[idx[[x]], 
            "Group"], collapse = ",")))
    }
    view.df$Covered_Seqs <- unlist(cvd)
    # percent format the cvg ratio
    if ("Coverage_Ratio" %in% colnames(view.df)) {
        view.df$Coverage_Ratio <- paste(round(view.df$Coverage_Ratio, 4) * 100, "%", 
            sep = "")
    }
    excl <- NULL
    if (mode.directionality == "fw") {
        excl <- grep("_rev", colnames(view.df))
    } else if (mode.directionality == "rev") {
        excl <- grep("_fw", colnames(view.df))
    }
    excl.cols <- c("Direction", "primer_length_fw", "primer_length_rev")
    excl.idx <- sapply(excl.cols, function(x) grep(x, colnames(view.df)))
    excl.idx <- unique(c(excl.idx, excl))
    if (length(excl.idx) != 0) {
        view.df <- view.df[, -excl.idx]
    }
    view.df <- openPrimeR:::view.input.primers(view.df, mode.directionality)
    return(view.df)
}
view.evaluated.primers <- function(primer.df, template.df, mode.directionality, view.cvg.individual) {
    # view evaluated primers 
    if (length(primer.df) == 0) {
        return(NULL)
    } else if (nrow(primer.df) == 0) {
        return(primer.df)
    }
    primer.df <- asS3(primer.df)
    if ("primer_coverage" %in% colnames(primer.df)) {
        view.df <- openPrimeR:::view.cvg.primers(primer.df, template.df, mode.directionality, view.cvg.individual)
    } else {
        view.df <- primer.df
    }
    return(view.df)
}
view.filtered.primers <- function(primer.df, template.df, mode.directionality, view.cvg.individual) {
    # view excluded primers message('viewing filtered primers:') message(primer.df)
    if (length(primer.df) == 0) {
        return(NULL)
    } else if (nrow(primer.df) == 0) {
        # still show empty df
        return(primer.df)
    }
    primer.df <- asS3(primer.df)
    excl.col <- "constraints_passed"
    # also remove all of the eval columns:
    eval.cols <- colnames(primer.df)[grep("EVAL_", colnames(primer.df))]
    excl.col <- c(excl.col, eval.cols)
    view.df <- openPrimeR:::exclude.cols(excl.col, primer.df)
    view.df <- view.evaluated.primers(view.df, template.df, mode.directionality, view.cvg.individual)
    return(view.df)
}
view.optimized.primers <- function(primer.df, template.df, mode.directionality, view.cvg.individual) {
    if (length(primer.df) == 0) {
        return(NULL)
    } else if (nrow(primer.df) == 0) {
        # still display an empty df
        return(primer.df)
    }
    view.df <- asS3(primer.df)
    if ("Cumulative_Coverage_Ratio" %in% colnames(view.df)) {
        view.df$Cumulative_Coverage_Ratio <- paste(round(view.df$Cumulative_Coverage_Ratio, 
            4) * 100, "%", sep = "")
    }
    view.df <- view.filtered.primers(view.df, template.df, mode.directionality, view.cvg.individual)
    # reorder columns: put ID first
    c.order <- c("ID")
    c.o <- setdiff(colnames(view.df), c.order)  # don't care about these cols in ordering
    cols <- c(c.order, c.o)
    view.df <- view.df[, cols]
    return(view.df)
}

