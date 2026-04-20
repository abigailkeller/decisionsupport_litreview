library(revtools)

# import bibliographic information
data <- readRDS("data/refs_deduplicated.rds")

# subset to just journal articles (i.e., remove books, book chapters, conference papers)
data <- data[data$type == "JOUR", ]

screen_abstracts(data)
