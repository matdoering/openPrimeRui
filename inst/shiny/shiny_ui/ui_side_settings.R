##############
# UI side panel for constraints of the tool
################
tabPanel("Settings", value = "constraint_panel",
     icon = icon("wrench"),
     br(),
     h2(class="inline", "Settings"),
     br(),
     br(),
     div(p("Specify the conditions for computing the physicochemical properties of the primers.", 
        openPrimeRui:::create.help.button("settings_overview")),
        class = "one"
     ),
     ####
     shinyBS::bsCollapse(id = "input_settings_collapse", 
        open = "load_settings_panel",
        shinyBS::bsCollapsePanel(
            ###############
            # LOAD SETTINGS
            ###############
            tagList(icon("wrench"), 
                    "Settings"
            ),
            style = "primary",
            value = "load_settings_panel",
            div(p("Please load the provided settings or specify a custom settings XML file."), class = "two"),

            # choose type of settings: default/personal
            radioButtons("load_settings_choice", 
                tagList(icon("floppy-disk", lib = "glyphicon"), 
                    "Settings source"),
                c("Available" = "default", 
                  "Personal" = "personal"),
                inline = TRUE
            ),
            shinyBS::bsTooltip("load_settings_choice", 
                "Load supplied or personal analysis settings?",
                    "right", options = list(container = "body")
            ),
            conditionalPanel("input.load_settings_choice == 'default'",
                ########
                # LOAD SUPPLIED SETTINGS
                #########
                selectizeInput("load_available_constraints", 
                    tagList(
                        icon = icon("wrench"),
                        "Available settings"
                    ),
                    choices = openPrimeRui:::get.available.settings.view(system.file(
                        "extdata", "settings", 
                        package = "openPrimeR"), initial = TRUE)
                    #selected = NULL,
                    #options = list(
                        #placeholder = 'Please choose a set of analysis settings',
                        #onInitialize = I('function() { this.setValue(""); }')
                    #)
                )
            ),
            conditionalPanel("input.load_settings_choice == 'personal'",
                #######
                # PERSONAL SETTINGS
                ########
                # input of xml constraint file
                fileInput(inputId = "load_constraints",  
                      label = tagList(icon("file"), 
                      "Settings XML file"), accept = "text/xml"
            ),
            shinyBS::bsTooltip("load_constraints", 
                    "Load constraint settings by selecting an xml file
                     from a previous analysis run.",
                    "right", options = list(container = "body")
                )
            ),
            # load settings button
            actionButton("load_settings_button", 
                "Load settings", icon = icon("check"),
                class = "actionStyle",
                style = "primary"
            ),
            # confirm settings button
            div(class = "rightAligned", 
                shinyBS::bsButton("confirm_settings_choice", 
                "Confirm loaded settings", icon = icon("check"),
                class = "actionStyleSmall", disabled = TRUE,
                style = "primary")
            )
        ),
        shinyBS::bsCollapsePanel(
            ################
            # BINDING CONDITIONS
            ##################
            tagList(icon("star"),
                "Coverage conditions"
            ),
            value = "binding_conditions_panel",
            div(p("Customize under which circumstances a primer is considered to cover a template sequence.",
                    openPrimeRui:::create.help.button("coverage_conditions")
                ),
                class = "two"
            ),
            shinyBS::bsTooltip("allowed_binding_region_definition", 
                "Require binding within the target region or only an overlap?",
                "right", options = list(container = "body")
            ),
            # allow mismatches?
            shinyBS::bsTooltip("allowed_mismatches", 
                paste0("Maximum number of mismatches between primers and templates.",
                "To limit computer memory consumption and runtime, choose a smaller value.", sep = "<br>"),
                "right", options = list(container = "body")
            ),
            shinyBS::bsTooltip("allowed_other_binding_ratio", 
                paste("The allowed off-target binding ratio of primers.",
                "<br>If this setting exceeds 0% then off-target binding is allowed but a warning is outputted if the off-target binding rate exceeds the specified cutoff."),
                "right", options = list(container = "body")
            ),
            shinyBS::bsTooltip("constraint_annealing_DeltaG", 
                "Exclude coverage events with high free energies of annealing.",
                "right", options = list(container = "body")
            ),
            shinyBS::bsTooltip("allowed_annealing_DeltaG", 
                "The minimal required annealing free energy.",
                "right", options = list(container = "body")
            ),
            shinyBS::bsTooltip("constraint_primer_efficiency", 
                paste("Filter coverage events with low hybridization efficiencies.",
                    "<br>",
                    "Wright ES (2016).",
                    "<br>",
                    "“Using DECIPHER v2.0 to Analyze Big Biological Sequence Data in R.”",
                    "<br>",
                    "The R Journal, 8(1), pp. 352-359."),
                "right", options = list(container = "body")
            ),
            shinyBS::bsTooltip("allowed_primer_efficiency", 
                  "The allowed range of primer hybridization efficiencies." ,
                    "right", options = list(container = "body")
            ),
            shinyBS::bsTooltip("constraint_coverage_model", 
                "Filter coverage events that are expected to be falsely reported using openPrimeR's logistic regression model.",
                "right", options = list(container = "body")
            ),
            shinyBS::bsTooltip("allowed_coverage_model", 
                  "The maximal allowed rate of falsely called coverage events.",
                    "right", options = list(container = "body")
            ),
            shinyBS::bsTooltip("allowed_stop_codons", 
                "Consider coverage events that induce stop codons through mismatch binding?",
                "right", options = list(container = "body")
            ),
            shinyBS::bsTooltip("allowed_substitutions", 
                "Consider coverage events that induce amino acid substitions through mismatch binding?",
                "right", options = list(container = "body")
            ),
            shinyBS::bsTooltip("are_mismatches_allowed", 
                "Allow primers to cover templates that bind with mismatches?",
                "right", options = list(container = "body")
            ),
            # disallow mismatches at 3' end?
            shinyBS::bsTooltip("allow_3prime_mismatch", 
                 "Allow primer-template mismatches in the last 3\\' bases?",
                "right", options = list(container = "body")
            ),
            shinyBS::bsTooltip("disallowed_mismatch_pos", 
                 "The number of positions from the 3\\' end where mismatches should be prevented.",
                "right", options = list(container = "body")
            ),
            ######
            # BASIC COVERAGE CONDITIONS
            ######
            br(),# not so much space? 
            #############
            # COVERAGE CONDITION COLLAPSE
            ####################
             shinyBS::bsCollapse(id = "coverage_conditions_collapse", 
                open = "basic_cvg_conditions",
                shinyBS::bsCollapsePanel(tagList(icon("star-o"), "Basic conditions"),
                    value = "basic_cvg_conditions",
            #h4(class="inline", "Basic conditions"),
            div(p("The basic coverage conditions provide requirements for identifying possible amplification events: the maximal number of allowed mismatches and the allowed binding region determine which coverage events can be detected."), 
                class = "one"
            ), 
            # no table header here to make it cleaner
            HTML("<table class=constraint-table>"),
                openPrimeRui:::create.constraint.table.row(
                    radioButtons("allowed_binding_region_definition", 
                        tagList(
                            #icon("bookmark"), 
                            "Binding region definition"
                        ),
                        c("Within" = "within", 
                          "Any overlap" = "any"),
                        inline = TRUE
                ),
                    sliderInput("allowed_other_binding_ratio", 
                        tagList("Off-target binding ratio"),
                        min = 0, max = 1, 
                        value = 1.0, round = TRUE, step = 0.01
                    ),
                    NULL
            ),
            openPrimeRui:::create.constraint.table.row(
                radioButtons("are_mismatches_allowed", 
                    tagList("Mismatch binding"),
                    c("Allowed" = "active", "Forbidden" = "inactive"),
                    inline = TRUE
                ),
                sliderInput("allowed_mismatches", 
                    tagList("Number of mismatches"),
                    min = 0, max = 20, 
                    value = 3,
                ),
                NULL
            ),
            HTML("</table>")
            ),
            shinyBS::bsCollapsePanel(tagList(icon("star"), "Extended conditions"),
                value = "ext_cvg_conditions",
            #########
            # EXTENDED COVERAGE CONDITIONS
            #########
            div(p("The extended coverage conditions define the way in which coverage events are called."), 
                class = "two"
            ),
            shinyBS::bsCollapse(id = "extended_cvg_collapse", 
                open = "ext_cvg_conditions_binding",
            # BINDING CONDITIONS
            shinyBS::bsCollapsePanel(tagList(icon("star"), "Binding conditions"),
                value = "ext_cvg_conditions_binding",
                p("For typical applications, selecting a single binding condition is sufficient. The coverage criteria should be more stringent when designing primers than when evaluating primers in order to ensure that all primers actually allow for amplification."),
                HTML("<table class=constraint-table>"),
                    openPrimeRui:::create.constraint.table.row( 
                        radioButtons("constraint_annealing_DeltaG", 
                            tagList("Annealing energy", 
                                openPrimeRui:::create.help.button("annealing_DeltaG")
                            ),
                            c("On" = "active", "Off" = "inactive"), 
                            selected = "inactive", inline = TRUE
                        ),
                        sliderInput("allowed_annealing_DeltaG", 
                            "Required energy of annealing", 
                            min = -20, max = 0, 
                            round = TRUE, step = 1,
                            value = c(max = -5),
                            post = "<sup>kcal</sup>&frasl;<sub>mol</sub>"
                        ),
                        NULL
                    ),
                    openPrimeRui:::create.constraint.table.row( 
                        radioButtons("constraint_primer_efficiency", 
                        tagList("Amplification efficiency", 
                            openPrimeRui:::create.help.button("primer_efficiency")
                        ),
                        c("On" = "active", "Off" = "inactive"), 
                        selected = "inactive", inline = TRUE
                    ),
                    sliderInput("allowed_primer_efficiency", 
                        "Required primer efficiency", 
                        min = 0, max = 1, 
                        round = TRUE, step = 0.001,
                        value = c(min = 0.001, max = 1)
                    ),
                    NULL
                ),
                openPrimeRui:::create.constraint.table.row( 
                    radioButtons("constraint_coverage_model", 
                        tagList("Coverage model", 
                            openPrimeRui:::create.help.button("coverage_model")
                        ),
                        c("On" = "active", "Off" = "inactive"), 
                        selected = "inactive", inline = TRUE
                    ),
                    sliderInput("allowed_coverage_model", 
                        "Permissible false positive rate", 
                        min = 0, max = 1, 
                        round = TRUE, step = 0.001,
                        value = c(max = 0.1)
                    ),
                    NULL
                ),
                openPrimeRui:::create.constraint.table.row(
                        radioButtons("allow_3prime_mismatch", 
                            tagList("3' Mismatches"),
                            c("Allowed" = "active", "Forbidden" = "inactive"),
                            inline = TRUE, selected = "active"
                        ),
                        sliderInput("disallowed_mismatch_pos", 
                            tagList("Number of 3' positions"),
                            min = 0, max = 10, 
                            value = 5
                        ),
                        NULL
                ),
                HTML("</table>")
            ),
            # CODON DESIGN
            shinyBS::bsCollapsePanel(tagList(icon("star"), "Codon design"),
                value = "ext_cvg_conditions_mismatches",
                p("Prevent the calling of coverage events for mismatch binding events that would have a functional impact on the amplicons.",
                    openPrimeRui:::create.help.button("codon_design")
                ),
                HTML("<table class=constraint-table>"),
                    openPrimeRui:::create.constraint.table.row(
                        radioButtons("allowed_stop_codons", 
                            tagList("Stop codons"),
                            c("Allowed" = "active", "Forbidden" = "inactive"), 
                            inline = TRUE, selected = "inactive"
                        ),
                        HTML(""),
                        NULL
                    ),
                    openPrimeRui:::create.constraint.table.row(
                        radioButtons("allowed_substitutions", 
                            tagList("Substitutions"),
                            c("Allowed" = "active", "Forbidden" = "inactive"), 
                            inline = TRUE, selected = "inactive"
                        ),
                        HTML(""),
                        NULL
                    ),
                HTML("</table>")
           ) # close codon panel
           ) # close extended collapse
           ) 
           ), # end of coverage conditions collapse
           div(class = "rightAligned", 
                # confirm binding conditions  button
                actionButton("confirm_binding_conditions", 
                    "Confirm coverage conditions", 
                     icon = icon("check"), 
                     class = "actionStyleSmall", 
                     style="color: #fff; background-color: #337ab7; border-color: #2e6da4"
                )
            )
     ), # close binding conditions panel
     shinyBS::bsCollapsePanel(tagList(icon("filter"), "Constraints"),
        ###########
        # SETTINGS CUSTOMIZATION
        ###########
        value = "customize_settings_panel",
        style = "default",
        div(p("Please use the radio buttons to select the properties that you would like to consider. ", 
              "The ", tags$i("Setting"), 
              " column indicates the desired range of values 
              for each property. The ", tags$i("Limit"), 
              " column defines the extend and speed at which ",
              " the constraints are relaxed if it is not possible ",
              " to obtain a primer set fulfilling the required properties.",
            openPrimeRui:::create.help.button("overview_filters")
            ),
            class = "two"
        ),
        ########
        # constraint selectors: activate/deactivate/reset
        #########
        actionButton("deactivate_all_filters", "Deselect all", icon = icon("remove", lib = "glyphicon"), class = "actionStyleSmall"),
        actionButton("activate_all_filters", "Select all", icon = icon("ok", lib = "glyphicon"), class = "actionStyleSmall"),
        br(),
        br(),
        ######
        # CONSTRAINT TABLE
        ##########
        HTML("<table class=constraint-table><tr><th><i class='fa fa-filter'></i> Constraint</th><th><i class='glyphicon glyphicon-resize-small'></i> Setting</th><th><i class='glyphicon glyphicon-resize-full'></i> Limit</th></tr>"), # initialize the table
        ###########
        # add rows to constraint table. all calls are of the same fashion:
        #   1. constraint radio buttons
        #   2. filtering settings
        #   3. limit setting for relaxation
        ##########
        # Coverage
        ###########
        openPrimeRui:::create.constraint.table.row( 
            radioButtons("constraint_primer_coverage", # active?
                tagList("Coverage", openPrimeRui:::create.help.button("primer_coverage")),
                c("On" = "active", "Off" = "inactive"), inline = TRUE
            ),
            sliderInput("allowed_primer_coverage", "",  # allowed range
                min = 0, max = 100, 
                value = c(min = 1)
            ),
            HTML("")
        ),
        #####
        # primer length
        #####
        openPrimeRui:::create.constraint.table.row(
            radioButtons("constraint_primer_length", 
                tagList("Primer length", 
                    openPrimeRui:::create.help.button("primer_length")
                ),
                c("On" = "active", "Off" = "inactive"),
                inline = TRUE
            ),
            sliderInput("allowed_primer_length", "", 
                min = 1, max = 50, 
                value = c(min = 18, max = 22)
            ),
            NULL # no relaxation limit used
        ),
        ##########
        # gc clamp
        ###########
        openPrimeRui:::create.constraint.table.row(
            radioButtons("constraint_gc_clamp", 
                tagList("GC clamp",
                    openPrimeRui:::create.help.button("gc_clamp")
                ),
                c("On" = "active", "Off" = "inactive"), 
                inline = TRUE
            ),
            sliderInput("allowed_gc_clamp", "", 
                min = 0, max = 5, 
                value = c(min = 1, max = 3)
            ),
            sliderInput("limit_allowed_gc_clamp", "", 
                min = 0, max = 5,
                value = c(min = 0, max = 4)
            )
        ),
        ####
        # gc ratio
        ######
        openPrimeRui:::create.constraint.table.row(
            radioButtons("constraint_gc_ratio", 
                tagList("GC ratio", 
                    openPrimeRui:::create.help.button("gc_ratio")
                ),
                c("On" = "active", "Off" = "inactive"), 
                inline = TRUE
            ),
            sliderInput("allowed_gc_ratio", "",
                min = 0, max = 1, 
                value = c(min = 0.4, max = 0.6)
            ),
            sliderInput("limit_allowed_gc_ratio", "",
                min = 0, max = 1, 
                value = c(min = 0.3, max = 0.7)
           )
        ),
        #######
        # run length
        #######
        openPrimeRui:::create.constraint.table.row(
            radioButtons("constraint_no_runs", 
                tagList("Run length", 
                    openPrimeRui:::create.help.button("run_length")
                ),
                c("On" = "active", "Off" = "inactive"),
                inline = TRUE
            ),
            sliderInput("allowed_no_runs", "", 
                min = 0, max = 10,
                value = c(min = 0, max = 4)
            ),
            sliderInput("limit_allowed_no_runs", "",
                min = 0, max = 10,
                value = c(min = 0, max = 6)
            )
        ),
        #######
        # number of repeats
        ########
        openPrimeRui:::create.constraint.table.row(
            radioButtons("constraint_no_repeats",
                tagList("Repeat length", 
                    openPrimeRui:::create.help.button("repeat_length")
                ), 
                c("On" = "active", "Off" = "inactive"),
                inline = TRUE
            ),
            sliderInput("allowed_no_repeats", "", 
                min = 0, max = 10, 
                value = c(min = 0, max = 4)
            ),
            sliderInput("limit_allowed_no_repeats", "",
                min = 0, max = 10,
                value = c(min = 0, max = 6)
            )
        ),
        ######
        # melting temperature filter
        #######
        openPrimeRui:::create.constraint.table.row( 
            radioButtons("constraint_melting_temp_range",
                tagList(HTML(openPrimeR:::constraints_to_unit("melting_temp_range", format.type = "HTML")[[1]]), 
                    openPrimeRui:::create.help.button("melting_temperature")
                ), 
                c("On" = "active", "Off" = "inactive"), 
                selected = "active", inline = TRUE
            ),
            sliderInput("allowed_melting_temp_range", "",
                min = 40, max = 90, 
                value = c(min = 55, max = 65),
                post = "&#8451;"
            ),
            sliderInput("limit_allowed_melting_temp_range", "",
                min = 40, max = 90,
                value = c(min = 45, max = 75),
                post = "&#8451;"
            )
        ),
        # melting temperature difference
        openPrimeRui:::create.constraint.table.row(
            radioButtons("constraint_melting_temp_diff", 
                tagList(HTML(openPrimeR:::constraints_to_unit("melting_temp_diff", format.type = "HTML")[[1]]),
                    openPrimeRui:::create.help.button("opti_melting_temp")
                ),
                c("On" = "active", "Off" = "inactive"),
                selected = "active", 
                inline = TRUE
            ),
            sliderInput("allowed_melting_temp_diff", "", 
                min = 0, max = 15, 
                value = c(min = 0, max = 5), 
                post = "&#8451"
            ),
            sliderInput("limit_allowed_melting_temp_diff", "", 
                min = 0, max = 15, 
                value = c(min = 0, max = 8),
                post = "&#8451"
            )
        ),
        ######
        # secondary structure: filtering constraint
        ########
        openPrimeRui:::create.constraint.table.row(
            radioButtons("constraint_secondary_structure", 
                tagList(HTML("Secondary structure &Delta;G"), 
                    openPrimeRui:::create.help.button("secondary_structure")
                ),
                c("On" = "active", "Off" = "inactive"), 
                selected = "inactive", inline = TRUE
            ),
            sliderInput("allowed_secondary_structure", "", 
                min = -10, max = 0, step = 0.1, 
                value = c(min = -1), 
                post = "<sup>kcal</sup>&frasl;<sub>mol</sub>"
            ),
            sliderInput("limit_allowed_secondary_structure", "", 
                min = -10, max = 0, 
                value = c(min = -2), 
                post = "<sup>kcal</sup>&frasl;<sub>mol</sub>"
            )
        ),
        ####
        # primer specificity
        #######
        openPrimeRui:::create.constraint.table.row( 
            radioButtons("constraint_primer_specificity", 
                tagList("Specificity", 
                    openPrimeRui:::create.help.button("primer_specificity")
                ), 
                c("On" = "active", "Off" = "inactive"), 
                selected = "active", inline = TRUE
            ),
            sliderInput("allowed_primer_specificity", "", 
                min = 0, max = 1, 
                value = c(min = 1, max = 1)
            ),
            sliderInput("limit_allowed_primer_specificity", "",
                min = 0, max = 1,
                value = c(min = 0.8, max = 1)
            )
        ),
        ####
        # self dimerization
        ######
        openPrimeRui:::create.constraint.table.row(
            radioButtons("constraint_self_dimerization", 
                tagList(HTML("Self-dimerization &Delta;G"), 
                    openPrimeRui:::create.help.button("self_complementarity")
                ), 
                c("On" = "active", "Off" = "inactive"), 
                selected = "active", inline = TRUE
            ),
            sliderInput("allowed_self_dimerization", "", 
                min = -15, 
                max = 0, 
                value = c(min = -5), 
                post = "<sup>kcal</sup>&frasl;<sub>mol</sub>"
            ),
            sliderInput("limit_allowed_self_dimerization", "", 
                min = -15, max = 0, 
                value = c(min = -12), 
                post = "<sup>kcal</sup>&frasl;<sub>mol</sub>"
            )
        ),
        ######
        # cross-dimerization for filtering
        #####
        openPrimeRui:::create.constraint.table.row(
            radioButtons("constraint_cross_dimerization", 
                tagList(HTML("Cross-dimerization &Delta;G"), 
                openPrimeRui:::create.help.button("cross_complementarity")), c("On" = "active", "Off" = "inactive"), 
                selected = "inactive", inline = TRUE),
            sliderInput("allowed_cross_dimerization", "", 
                min = -15, max = 0, 
                value = c(min = -8), 
                post = "<sup>kcal</sup>&frasl;<sub>mol</sub>"),
            sliderInput("limit_allowed_cross_dimerization", "", 
                min = -15, max = 0, 
                value = c(min = -12), 
                post = "<sup>kcal</sup>&frasl;<sub>mol</sub>"
            )
        ),
        #####################
        # finalize table
        HTML("</table>"),
        # confirm constraints button
        div(class = "rightAligned", 
            actionButton("confirm_constraints", 
            "Confirm constraints", 
            icon = icon("check"), 
            class = "actionStyleSmall", 
            style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
        ),
        ########
        # filtering tooltips for table entries
        #######
        shinyBS::bsTooltip("constraint_primer_coverage", "Filter primers covering less templates than specified.",
                    "right", options = list(container = "body")),
        shinyBS::bsTooltip("constraint_primer_length", "Specify the desired number of primer nucleotides.",
                  "right", options = list(container = "body")),
        shinyBS::bsTooltip("constraint_gc_clamp", "Specify the desired number of GCs at the 3\\' end of primers.",
                  "right", options = list(container = "body")),
        shinyBS::bsTooltip("constraint_gc_ratio", "Specify the desired ratio of GCs among all primer nucleotides.",
                  "right", options = list(container = "body")),
        shinyBS::bsTooltip("constraint_no_runs", "Specify the longest allowed single-nucleotide run in a primer (e.g. AAAACG has a run of 4 adenosines).",
                  "right", options = list(container = "body")),
        shinyBS::bsTooltip("constraint_no_repeats", "Specify the longest allowed number of dinucleotide repeats in a primer (e.g. ACACGT has 2 repeats of the AC dinucleotide).",
                  "right", options = list(container = "body")),
        shinyBS::bsTooltip("constraint_melting_temp_range", "Specify the desired melting temperatures of primers (i.e. the temperature at which 50% of the primer is bound to the template).",
                  "right", options = list(container = "body")),
        shinyBS::bsTooltip("constraint_secondary_structure", "Filter primers exhibiting secondary structures that are below the free energy cutoff.",
                  "right", options = list(container = "body")),
        shinyBS::bsTooltip("constraint_primer_specificity", "Filter primers whose binding specificity is smaller than the specified value.",
                  "right", options = list(container = "body")),
        shinyBS::bsTooltip("constraint_self_dimerization", "Filter self-complementary primers whose free energies are below the specified cutoff.",
                  "right", options = list(container = "body")),
        shinyBS::bsTooltip("constraint_cross_dimerization", "Filter cross-complementary primers whose free energies are below the specified cutoff.",
                  "right", options = list(container = "body")),
        shinyBS::bsTooltip("help_overview_filters", "View help on the filtering constraints.",
                  "right", options = list(container = "body")),
        shinyBS::bsTooltip("constraint_melting_temp_diff", "The maximum allowed difference in melting temperatures between primers in a set.",
                      "right", options = list(container = "body"))
    ), # close collapse panel of constraints
    shinyBS::bsCollapsePanel(tagList(icon("flask"), "PCR conditions"),
        #########
        # PCR SETTINGS
        ##########
            value = "customize_general_settings_panel",
            style = "default",
            div(p("The PCR parameters impact the computation of some constraints. 
                  For example, melting temperature computations are influenced by the ion concentration.", 
                openPrimeRui:::create.help.button("pcr_settings")),
                  class = "two"
            ),
            # annealing temp not relevant for designing primers:
            conditionalPanel("input.primer_analysis_type != 'design'", 
                # set annealing temperature
                shinyBS::bsTooltip("automatic_annealing_temp", 
                    "Whether a suitable annealing temperature should be detected automatically.",
                    "right", options = list(container = "body")
                ),
                radioButtons("automatic_annealing_temp",
                    tagList(icon("thermometer"),
                    "Automatic annealing temperature determination"), 
                    c("On" = "active", "Off" = "inactive"), 
                    selected = "active", inline = TRUE
                ),
                conditionalPanel("input.automatic_annealing_temp == 'inactive'", 
                    # manually specified annealing temp
                    sliderInput("annealing_temp", 
                        tagList(icon("thermometer"), 
                        "Target annealing temperature"), 
                        50, # thermometer icon not yet available
                        min = 30, max = 80, 
                        post = "&#8451"
                    ),
                    shinyBS::bsTooltip("annealing_temp", 
                        "The PCR annealing temperature.",
                        "right", options = list(container = "body")
                    )
                )
            ),
            # Taq polymerase?
            radioButtons("use_taq_polymerase", 
                tagList(
                    icon("flask"),
                    "Polymerase"
                ),
                c("Taq" = "active", "Non-Taq" = "inactive"),
                inline = TRUE
            ), 
            shinyBS::bsTooltip("use_taq_polymerase", 
                "Whether a Taq polymerase or another type of polymerase is used.",
                    "right", options = list(container = "body")
            ),
            # number of PCR cycles:
            sliderInput("cycles", 
                tagList(icon("repeat", lib = "glyphicon"), 
                        "Number of PCR cycles"),
                1000,
                min = 1, max = 100, 
                step = 1
            ),
            shinyBS::bsTooltip("cycles", 
                "The number of PCR cycles.",
                "right", options = list(container = "body")
            ),
            # sodium ion concentration
            sliderInput("Na_concentration", 
                tagList(icon("flask"), HTML("[Na<sup>+</sup>]")), 
                0,
                min = 0, max = 100, 
                post = "mM", step = 0.1
            ), # unit: mM
            shinyBS::bsTooltip("Na_concentration", 
                "The concentration of monovalent sodium ions for PCR.",
                "right", options = list(container = "body")
            ),
            # magnesium ion concentration
            sliderInput("Mg_concentration", 
                tagList(icon("flask"), HTML("[Mg2<sup>+</sup>]")), 
                1.5, # in mM
                min = 0, max = 100,
                post = "mM",
                step = 0.1
            ),
            shinyBS::bsTooltip("Mg_concentration", "The concentration of divalent magnesium ions for PCR.",
                    "right", options = list(container = "body")),
            # potassium ion concentration
            sliderInput("K_concentration", 
                tagList(icon("flask"), HTML("[K<sup>+</sup>]")), 
                50, # mM
                min = 0, max = 100, 
                post = "mM", step = 0.1
            ),
            shinyBS::bsTooltip("K_concentration", "The concentration of monovalent potassium ions for PCR.",
                      "right", options = list(container = "body")
            ),
            # tris buffer concentration
            sliderInput("Tris_concentration", 
                tagList(icon("flask"), HTML("[Tris]")), 
                0, # mM
                min = 0, max = 100, 
                post = "mM",
                step = 0.1
            ),
            shinyBS::bsTooltip("Tris_concentration", 
                    "The concentration of the Tris buffer for PCR.",
                    "right", options = list(container = "body")
            ),
            # primer concentration
            sliderInput("primer_concentration", 
                tagList(icon("flask"), "[Primer]"), 
                step = 0.01,
                200, # nM
                min = 0, max = 1000, 
                post = "nM"
            ),
            shinyBS::bsTooltip("primer_concentration", 
                "The PCR oligomer concentration.",
                "right", options = list(container = "body")
            ),
            sliderInput("template_concentration", 
                tagList(icon("flask"), "[Template]"), 
                step = 0.01,
                200, # nM
                min = 0, max = 1000, post = "nM"
            ),
            shinyBS::bsTooltip("template_concentration", 
                    "The concentration of template molecules.",
                    "right", options = list(container = "body")
            ),
            # confirm settings button
            div(class = "rightAligned", 
                shinyBS::bsButton("confirm_PCR_settings", 
                "Confirm settings", icon = icon("check"),
                class = "actionStyleSmall", disabled = TRUE,
                style = "primary")
            )
        ), # close bscollapse for general settings
        shinyBS::bsCollapsePanel(
            tagList(icon("menu-hamburger", lib = "glyphicon"),
                "Other settings"),
            #########
            # OTHER SETTINGS
            ##########
            value = "customize_other_settings_panel",
            style = "default",
                #########
                # MULTI CORE SETTING
                ##########
                sliderInput("no_of_cores",
                    tagList(icon = icon("tachometer"),
                        "Number of used computer processors"), 
                        min = 1, max = parallel::detectCores(), 
                        value = min(parallel::detectCores(), 2), step = 1
                ),
                shinyBS::bsTooltip("no_of_cores", 
                    "The number of CPU cores to be used for parallel computations.",
                    "right", options = list(container = "body")
                )
            #)
        ) # end other settings bscollapse
    ), # end bscollapse for settings
    #########
    # settings reset button:
    ##########
    actionButton("reset_constraints", "Reset settings", icon = icon("refresh", lib = "glyphicon"), class = "actionStyleSmall"),
    shinyBS::bsTooltip("reset_constraints", 
        "Reset the current settings to the defaults specified in the loaded settings file.",
            "right", options = list(container = "body")
    )

) # end tabpanel for settings

