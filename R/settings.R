get.available.settings <- function(app.settings.folder, taq.PCR = NULL, analysis.mode = NULL, initial = FALSE) {
    # select the setting files that correspond to the user input
    setting.files <- list.files(app.settings.folder, ".xml", full.names = TRUE)
    # select only setting corresponding to selected polymerase
    if (length(taq.PCR) != 0) {
        if (taq.PCR) {
            # taq PCR
            sel <- grep("_Taq_", basename(setting.files))
        } else {
            # non-taq PCR
            sel <- grep("_Non-Taq_", basename(setting.files))
        }
        setting.files <- setting.files[sel]
    }
    if (length(analysis.mode) != 0) {
        if (analysis.mode == "evaluate" || analysis.mode == "compare") {
            sel <- grep("evaluate", basename(setting.files))
        } else { # design
            sel <- grep("design", basename(setting.files))
        }
        setting.files <- setting.files[sel]
    }
    if (length(setting.files) > 1 & initial) {
        # don't choose a setting yet (UI will still change)?
        setting.files <- setting.files[grep("evaluate", setting.files)[1]]
    }
    return(setting.files)
}
get.available.settings.view <- function(app.settings.folder, taq.PCR = NULL, analysis.mode = NULL, initial = FALSE) {
    fnames <- get.available.settings(app.settings.folder, taq.PCR, analysis.mode, initial = initial)
    if (length(fnames) == 0) {
        return(NULL)
    }
    bnames <- basename(fnames)
    bnames <- sub("^([^.]*).*", "\\1", bnames)
    return(bnames)
} 

create.constraint.table.row <- function(radio.button, slider.setting, slider.limit, help.element = NULL) {
    na.element <- "" # could do some other style (icon?)
    if (length(radio.button) == 0) {
        radio.button <- na.element 
    }
    if (length(slider.setting) == 0) {
        slider.setting <- na.element    
    }
    nbr.cols <- 3
    if (length(slider.limit) == 0) {
        # don't show slider limit column
        nbr.cols <- 2
    }
    if (length(help.element) == 0) {
        help.element <- na.element
    }
    if (nbr.cols == 3) { 
        out <- tagList(HTML("<tr>
                    <td>"), 
                    radio.button,
                HTML("</td>",
                    "<td>"),
                    slider.setting,
                HTML("</td>
                    <td>"
                ),
                slider.limit,
                HTML("</td></tr>"))
    } else if (nbr.cols == 2) {
         out <- tagList(HTML("<tr>
                    <td>"), 
                    radio.button,
                HTML("</td>",
                    "<td>"),
                    slider.setting,
                HTML("</td></tr>"))
    } else {
        out <- NULL
    }
    return(out)
}


