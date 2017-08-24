################
# Frontend elements of the shiny app
#################
dimer.text.info <- function(dimer.data, primer.df, deltaG.cutoff) {
    # dimer.data: worst-case conformation for primer pairs
    if (length(dimer.data) == 0) {
        return(NULL)
    }
    dimer.idx <- which(dimer.data$DeltaG < deltaG.cutoff)
    possible.dimers <- nrow(dimer.data)  # the number of primer pairs above the score cutoff
    N.dimers <- length(dimer.idx)
    ratio <- round((N.dimers/possible.dimers) * 100, 2)
    ID.col <- ifelse("Primer" %in% colnames(dimer.data), "Primer", c("Primer_1", "Primer_2"))
    N.primers <- length(unique(unlist(dimer.data[dimer.idx, ID.col])))
    ratio.primers <- round(N.primers/nrow(primer.df) * 100, 2)
    text <- paste("At the current &Delta;G cutoff of ", deltaG.cutoff, " kcal/mol, ", 
        N.dimers, " (", ratio, "%) of ", possible.dimers, " primer pairings are considered dimerizing and ", 
        N.primers, " (", ratio.primers, "%) of ", nrow(primer.df), " primers are involved in these dimerizations.", 
        sep = "")
    return(text)
}

create.design.string <- function(allowed.mismatches, mode.directionality, 
                                 init.mode, opti.algo, template.df,
                                 required.cvg) {
    init <- ifelse(init.mode == "naive", "divergent", "related")
    algo <- ifelse(opti.algo == "Greedy", "a greedy algorithm",
                    "an integer linear program")
    mm.string <- ifelse(allowed.mismatches <= 1, "mismatch", "mismatches")
    dir <- ifelse(mode.directionality == "fw", "forward",
                ifelse(mode.directionality == "rev", "reverse",
                        "pairs of"))
    req.cvg <- paste0(round(required.cvg * 100, 2), "%")
    msg <- paste0("Design ", dir, " primers for ", nrow(template.df), " ", init, " template sequences with at most ", allowed.mismatches, " ", mm.string, " using ", algo, " (target coverage: ", req.cvg, ")?")
    return(msg)
}

myHeaderPanel <- function (title, windowTitle = title, style = NULL) 
{
    tagList(tags$head(tags$title(windowTitle)), 
        div(style = NULL, id = "headerPanel", class = "col-sm-12", title)
    )
}

create.Tm.text <- function(Tm.range, Tm.diff) {
    Tm.range <- round(Tm.range, 2)
    Tm.diff <- round(Tm.diff, 2)
    Tm.r <- paste("from ", Tm.range[1], "&#8451; to ", Tm.range[2], "&#8451;", sep = "")
    text <- paste("The melting temperature ranges ", Tm.r, " (&Delta;T<sub>m</sub> = ", Tm.diff, "&#8451;).", sep = "")
    return(text)
}


traffic_light <- function() {
    code <- '<div id="light" style = display: inline-block;">
        <span id="red"></span>
        <span id="orange"></span>
        <span id="green"></span>
    </div>'
    return(HTML(code))
}
