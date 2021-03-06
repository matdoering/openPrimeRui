######## Shiny server functionalities for the help pages

#HelpObserver <- observe({
    ## HelpObserver is just there to summarize all help events input help
    ##############
    # TEMPLATES
    ###############
    observeEvent(input$help_input_templates, {
        openPrimeRui:::view.template.help.element(session, "help_input_templates_overview")
    })
    observeEvent(input$help_input_templates_comparison, {
        openPrimeRui:::view.template.help.element(session, "help_input_templates_overview")
    })
    observeEvent(input$help_input_templates_uniform, {
        openPrimeRui:::view.template.help.element(session, "help_input_templates_allowed")
    })
    observeEvent(input$help_input_templates_allowed, {
        openPrimeRui:::view.template.help.element(session, "help_input_templates_allowed")
    })
    observeEvent(input$help_input_templates_header, {
        openPrimeRui:::view.template.help.element(session, "help_input_templates_header")
    })
    ################
    # PRIMERS
    ##################
    observeEvent(input$help_input_primers_comparison, {
        # Comparison primer input
        view.primer.help.element(session, "help_input_primers_comparison")
    })
    observeEvent(input$help_input_primers_overview, {
        # Input of primers for analysis
        view.primer.help.element(session, "help_input_primers_overview")
    })
    observeEvent(input$help_init_initialization, {
        # specifying the properties of design primers
        openPrimeRui:::view.opti.help.element(session, "help_init_initialization")
    })
    #############
    # SETTINGS
    ##############
    ########
    # a) OVERALL SETTINGS
    #########
    observeEvent(input$help_settings_overview, {
        # overall settings info
        openPrimeRui:::view.constraint.general.help("help_constraints_overview", session)
    })
    observeEvent(input$help_coverage_conditions, {
        # coverage conditions
        openPrimeRui:::view.cvg.help("help_tab_coverage_basic", session)
    })
    observeEvent(input$help_pcr_settings, {
        # PCR conditions
        openPrimeRui:::view.PCR.help(session)
    })
    #######
    # b) CONSTRAINTS
    #######
    # help for constraints
    observeEvent(input$help_overview_filters, {
        openPrimeRui:::view.filter.help("help_tab_overview_filters", session)
    })
    observeEvent(input$help_primer_coverage, {
        openPrimeRui:::view.filter.help("help_tab_primer_coverage", session)
    })
    observeEvent(input$help_primer_length, {
        openPrimeRui:::view.filter.help("help_tab_primer_length", session)
    })
    observeEvent(input$help_gc_clamp, {
        openPrimeRui:::view.filter.help("help_tab_gc_clamp", session)
    })
    observeEvent(input$help_gc_ratio, {
        openPrimeRui:::view.filter.help("help_tab_gc_ratio", session)
    })
    observeEvent(input$help_run_length, {
        openPrimeRui:::view.filter.help("help_tab_run_length", session)
    })
    observeEvent(input$help_repeat_length, {
        openPrimeRui:::view.filter.help("help_tab_repeat_length", session)
    })
    observeEvent(input$help_melting_temperature, {
        openPrimeRui:::view.filter.help("help_tab_melting_temperature", session)
    })
    observeEvent(input$help_opti_melting_temp, {
        # melting temp diff
        openPrimeRui:::view.filter.help("help_tab_melting_temperature_diff", session)
    })
    observeEvent(input$help_secondary_structure, {
        openPrimeRui:::view.filter.help("help_tab_secondary_structure", session)
    })
    observeEvent(input$help_primer_specificity, {
        openPrimeRui:::view.filter.help("help_tab_primer_specificity", session)
    })
    observeEvent(input$help_cross_complementarity, {
        openPrimeRui:::view.filter.help("help_tab_cross_complementarity", session)
    })
    observeEvent(input$help_self_complementarity, {
        openPrimeRui:::view.filter.help("help_tab_self_complementarity", session)
    })
    ########
    # c) Coverage conditions
    #########
    observeEvent(input$help_primer_efficiency, {
        openPrimeRui:::view.cvg.help("help_tab_primer_efficiency", session)
    })
    observeEvent(input$help_coverage_model, {
        openPrimeRui:::view.cvg.help("help_tab_coverage_model", session)
    })
    observeEvent(input$help_annealing_DeltaG, {
        openPrimeRui:::view.cvg.help("help_tab_annealing_DeltaG", session)
    })
    observeEvent(input$help_codon_design, {
        openPrimeRui:::view.cvg.help("help_tab_codon_design", session)
    })
    ################
    # ANALYSIS
    #################
    # EVALUATION
    observeEvent(input$help_eval_eval, {
        openPrimeRui:::view.eval.help.entry(session, "help_eval_eval")
    })
    # COMPARISON
    observeEvent(input$help_compare, {
        openPrimeRui:::view.compare.help(session)
    })
    # OPTIMIZATION
    observeEvent(input$help_opti_optimization, {
        openPrimeRui:::view.opti.help.element(session, "opti_optimization_help")
    })
    observeEvent(input$help_opti_optimization_overview, {
        openPrimeRui:::view.opti.help.element(session, "opti_optimization_help")
    })
    observeEvent(input$help_modify_binding_regions_secondary_structures, {
        # optimize template secondary structures
        openPrimeRui:::view.opti.help.element(session, "opti_templates_help")
    })
######### help pages end
#})
############################ 

output$helpPage <- renderUI({
    # read help page from external file and output it as HTML
    help.file <- "help.html"
    content <- readChar(help.file, file.info(help.file)$size)
    return(HTML(content))
})

output$iupac_ambig_table <- renderTable({
    # output a table with IUPAC ambiguities conversions
    iupac.table <- data.frame("IUPAC Code" = names(Biostrings::IUPAC_CODE_MAP), "Nucleotide" = sapply(strsplit(Biostrings::IUPAC_CODE_MAP, 
    split = ""), function(x) paste(x, collapse = " or ")))
    colnames(iupac.table) = c("IUPAC Code", "Nucleotide")
    return(iupac.table)
}, include.rownames = FALSE, caption = "Table 1: IUPAC ambiguity codes", caption.placement = getOption("xtable.caption.placement", 
    "bottom"), caption.width = getOption("xtable.caption.width", NULL))
