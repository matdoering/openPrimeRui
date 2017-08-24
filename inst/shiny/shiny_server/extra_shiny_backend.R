############
# Sets static paths for the shiny app: loaded in server.R
##############
server.src.folder <- system.file("shiny", "shiny_server", 
                package = "openPrimeRui")
source(file.path(server.src.folder, "extra_set_paths.R"))
AVAILABLE.TOOLS <- openPrimeR:::check.tool.function(frontend = TRUE)
# increase font size for ggplot objects for shiny:
OLD.GG.THEME <- ggplot2::theme_get()
ggplot2::theme_set(ggplot2::theme_grey(base_size = 20)) 
