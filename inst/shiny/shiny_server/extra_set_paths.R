#############
# Set paths for the shiny app 
###############
# frontend directory 
# important: if we don't use devtools, then the path MAY be set to the R library path instead of the local path -> tools/ won't be found!
# avoid using system.file!
if (exists("SHINY.PATH")) {
    appDir <- SHINY.PATH
} else {
    appDir <- system.file("shiny", package = "openPrimeRui")
}
src.ui.folder <- file.path(appDir, "shiny_ui")
##############
# help folders
############
help.folder <- file.path(appDir, "help")
www.folder <- file.path(appDir, "www")
help.eval.folder <- file.path(help.folder, "evaluation")
help.constraint.folder <- file.path(help.folder, "constraints")
help.filter.folder <- file.path(help.constraint.folder, "filters")
help.cvg.con.folder <- file.path(help.constraint.folder, "coverage")
help.opti.folder <- file.path(help.folder, "optimization")
help.opti.filter.folder <- file.path(help.constraint.folder, "optimization")
help.opti.options.folder <- file.path(help.opti.folder, "options")
help.opti.init.folder <- file.path(help.opti.options.folder, "initialization")
help.opti.opti.folder <- file.path(help.opti.options.folder, "optimization")
FAQ.folder <- file.path(help.folder, "FAQ")
help.input.folder <- file.path(help.folder, "input")
help.input.template.folder <- file.path(help.input.folder, "templates")
help.input.primer.folder <- file.path(help.input.folder, "primers")
