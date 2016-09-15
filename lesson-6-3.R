# Libraries
library(ggplot2)
library(dplyr)

# Data
species <- read.csv("data/species.csv", stringsAsFactors = FALSE)
surveys <- read.csv("data/surveys.csv", na.strings = "", stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput("pick_species",
                   label = "Pick a species",
                   choices = unique(species["species_id"]))
side <- sidebarPanel(h2("Options", align="center"), in1)
out1 <- textOutput("species_name")
tab1 <- tabPanel("Plot",
                 plotOutput("species_plot"))
tab2 <- tabPanel("Data",
                 dataTableOutput("species_table"))                 
out2 <- tabsetPanel(tab1, tab2)
main <- mainPanel(out1, out2)
tab <- tabPanel("Species",
                sidebarLayout(side, main))
ui <- navbarPage(title = "Portal Project", tab)

server <- function(input, output) {
  output[["species_name"]] <- renderText(
    species %>%
      filter(species_id == input[["pick_species"]]) %>%
      select(genus, species) %>%
      paste(collapse = ' ')
  )
  output[["species_plot"]] <- renderPlot(
    surveys %>%
      filter(species_id == input[["pick_species"]]) %>%
      ggplot(aes(year)) +
      geom_bar()
  )
  output[["species_table"]] <- renderDataTable(
    surveys %>%
      filter(species_id == input[["pick_species"]])
  )
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
