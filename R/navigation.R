#######################
# Functions for navigating through the app
#####################
unset.subprocess.busy <- function(session) {
    # unset busy status (computations are done)
    # remove the busy class (modal can be closed by user, blue background (style.css) disappears.
    shinyjs::removeClass(id = "BusyInfo", class = "busy") 
    toggleModal(session, "BusyInfo", toggle = "toggle")
}
set.subprocess.busy <- function(session) {
    # set busy status (compuations are running, block the app)
    shinyjs::addClass(id = "BusyInfo", class = "busy")
    #session$sendCustomMessage(type='jsCode', list(value = "$('#BusyInfo').modal('toggle')")) # show busy modal.
    toggleModal(session, "BusyInfo", toggle = "toggle")
}
update.following.navigation <- function(session, cur.phase, action) {
    # enable/disable following tabs depending on user action
    # cur.phase: templates/primers/settings
    # action: enable disable
    debug <- FALSE # if debug is on, navigation is not restricted here
    if (debug) {
        message("DEBUG mode active: update.following.navigation")
    } else {
        panels <- c("settingsPanel" = "primer_input_tab", 
                    "settingsPanel" = "constraint_panel",
                    "settingsPanel" = "analyze_panel")
         #message("updating tab navigation ...")
         if (action == "disable") { # disable all following navigation elements
             if (cur.phase == "templates") {
                panels <- panels
             } else if (cur.phase == "primers") {
                panels <- panels[2:length(panels)]
             } else if (cur.phase == "settings") {
                panels <- panels[3:length(panels)]
             } else {
                message(paste("nothing to change for phase: ", cur.phase, sep = ""))
             }
        } else { # action is "enable" -> activate only the following navigation element
            if (cur.phase == "templates") {
                panels <- panels[1]
             } else if (cur.phase == "primers") {
                panels <- panels[2]
             } else if (cur.phase == "settings") {
                panels <- panels[3]
             } else {
                message(paste("nothing to change for phase: ", cur.phase, sep = ""))
             }
        }
         for (i in seq_along(panels)) {
            panel_selector = paste("#", names(panels)[i], " li a[data-value=", panels[i], "]", sep = "")
            if (action == "disable") {
                #message("disabling:")
                shinyjs::disable(selector = panel_selector) 
                shinyjs::addClass(class = "disabled", selector = panel_selector) # add disabled class to grey out/change cursor (not done by shinyjs for selectors!!)
            } else {
                #message("enabling")
                shinyjs::enable(selector = panel_selector) 
                shinyjs::removeClass(class = "disabled", selector = panel_selector) # remove greyed-out color
            }
            #message(panel_selector)
         }
    }
}
 
reset.reactive.values <- function(values, keep = NULL) {
    # reset an input reactive values list to default values.
    # args:
    #   values: reactive values
    #   keep: vector of names in values to keep
    for (i in seq_len(length(names(values)))) {
        name <- names(values)[i]
        if (name %in% keep) { # don't remove
            next
        }
        c <- class(values[[name]])
        if (c != "NULL" && length(attributes(values[[name]])) == 0) {
            exp <- paste(class(values[[name]]), "(1)", sep = "")
            default.val <- eval(parse(text=exp))
        } else { # NULL or other non-basic class
            default.val <- NULL
        }
        values[[name]] <- default.val
        #print(paste0("reset.reactive.values():", name, " set to: ", default.val))
    }
}

switch.view.selection <- function(selected, tab, session) {
    # when frontend computed something (eval/filtering/optimization), change all selection sliders to the corresponding results
    #   selected: the results to be shown (all/filtered/optimized)
    #   tab: current main tab selected (input$main)
    #   session: current shiny session object
    #updateTabsetPanel(session, "main", selected = switch.primer.view(tab))
    updateSelectInput(session, "set_meta_selector", selected = selected)
}

