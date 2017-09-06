pacifyBiocCheck <- function() {
   # this is a hack to ensure that BiocCheck doesn't throw an error
   # for Shiny dependencies (e.g. DT, rmarkdown), which are not called 
   # in the R/ folder but only in inst/shiny/
   # other possibility to fix this -> create function in R/ folder (e.g. for rmarkdown calls)
   DT::styleColorBar(1,NULL)
   rmarkdown::metadata
}
