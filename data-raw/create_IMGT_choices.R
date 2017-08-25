# Create files indicating the fields that can be selected for retrieving data from IGMT
imgt.settings.location <- system.file("extdata", "IMGT_options",
                                          package = "openPrimeRui")
dir.create(imgt.settings.location)
openPrimeRui:::call.IMGT.settings.script(imgt.settings.location)
