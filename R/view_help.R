# HELP FUNCTIONS
view.help <- function(session) {
    updateTabsetPanel(session, "main", selected = "help")
}
# input: template help
view.template.help <- function(session) {
    view.help(session)
    updateNavlistPanel(session, "help_panel", selected = "help_templates")
}
view.template.help.element <- function(session, id) {
    view.template.help(session)
    updateTabsetPanel(session, "help_input_tabset", selected = id)
}
# input: primer help
view.primer.help <- function(session) {
    view.help(session)
    updateNavlistPanel(session, "help_panel", selected = "help_input_primers")
}
view.primer.help.element <- function(session, id) {
    view.primer.help(session)
    updateTabsetPanel(session, "help_input_primer_tabset", selected = id)
}
##############
# constraints
view.constraints.help <- function(session) {
    view.help(session)
    updateNavlistPanel(session, "help_panel", selected = "help_constraints")
}
view.PCR.help <- function(session) {
    view.constraints.help(session)
    updateTabsetPanel(session, "help_constraints_tab", selected="help_settings_PCR")
}
view.constraint.general.help <- function(id, session) {
    view.constraints.help(session)
    updateTabsetPanel(session, "help_constraints_tab", selected=id)

}
# constraints: filter 
view.filter.help <- function(id, session) {
    view.constraints.help(session)
    updateTabsetPanel(session, "help_constraints_tab", selected="help_filtering_constraints")
    # print(paste0("viewing filter help: ", id))
    updateTabsetPanel(session, "help_filters_tab", selected=id)
}
# view cvg constraint help
view.cvg.help <- function(id, session) {
    view.constraints.help(session)
    updateTabsetPanel(session, "help_constraints_tab", selected= "help_coverage_conditions")
    updateTabsetPanel(session, "help_cvg_constraints_tab", selected=id)
}

# constraints: optimization
view.opti.constraints.help <- function(session, id) {
   view.constraints.help(session)
    updateTabsetPanel(session, "help_constraints_tab", selected="help_opti_constraints")
    updateTabsetPanel(session, "help_opti_tab", selected=id)
}
##########
# evaluation help
view.eval.help <- function(session) {
    view.help(session)
    updateNavlistPanel(session, "help_panel", selected = "help_evaluation")
}
view.eval.help.entry <- function(session, id) {
    view.eval.help(session)
    updateTabsetPanel(session, "help_evaluation_tab", selected=id)
}
###
# compare help
###
view.compare.help <- function(session) {
    view.eval.help(session)
    updateTabsetPanel(session, "help_evaluation_tab",   selected="help_comparison")
}

#################
# optimization help
###
view.opti.help <- function(session) {
    view.eval.help(session)
    updateTabsetPanel(session, "help_evaluation_tab",   selected="help_optimization")
}
view.opti.help.element <- function(session, id) {
    view.opti.help(session)
    updateTabsetPanel(session, "help_optimization_operations", selected = id)
}
view.opti.init.help <- function(session) {
    view.opti.help(session)
    updateTabsetPanel(session, "help_optimization_operations", selected="opti_init")

}
view.opti.init.help.element <- function(session, id) {
    view.opti.init.help(session)

    updateTabsetPanel(session, "help_optimization_init",  selected = id)
}
######## end of help viewing functions ########

# help button creation
create.help.button <- function(id) {
    button.name <- paste("help_", id, sep = "")
    a <- actionButton(button.name, "", icon = icon("info-sign", lib = "glyphicon"),
        style='padding:0px; font-size:85%; border-width:0px; opacity:0%; background-color:#f5f5f5')
    return(a) 
}
 
