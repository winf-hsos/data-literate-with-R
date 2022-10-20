library(quarto)

quarto_preview_stop()

wd <- getwd()

# Create output directories ####
unlink("output", recursive = TRUE)
dir.create("output")
dir.create("output/data")
dir.create("output/scripts")
dir.create("output/docs")
dir.create("output/docs/basics")
dir.create("output/docs/data-loading")
dir.create("output/docs/data-transformation")
dir.create("output/docs/data-visualization")
dir.create("output/book")
dir.create("output/slides")

# Render single documents to PDF
qmd_list <- list.files("documents", ".qmd", full.names = TRUE, recursive = TRUE)
quarto_render(qmd_list, output_format = "pdf")

# Copy .pdf files
pdf_list <- list.files("documents", ".pdf", full.names = TRUE, recursive = TRUE)
pdf_dest_list <- gsub("documents/", "output/docs/", pdf_list)
file.copy(pdf_list, pdf_dest_list, overwrite = TRUE)

# Copy .R files
r_list <- list.files("scripts", ".R", full.names = TRUE, recursive = TRUE)
file.copy(r_list, "output/scripts", overwrite = TRUE)

# Copy the data files #### 
data_list <- list.files("data", ".csv", full.names = TRUE, recursive = TRUE)
data_list <- c(data_list, list.files("data", ".xlsx", full.names = TRUE, recursive = TRUE))
data_list <- c(data_list, list.files("data", ".rds", full.names = TRUE, recursive = TRUE))
file.copy(data_list, "output/data", overwrite = TRUE)

# Create a Rproj file ####
r_proj_file = "output/data-literate-with-R.Rproj"
file.create(r_proj_file)
lines <- c(
  "Version: 1.0",
  "RestoreWorkspace: Yes",
  "SaveWorkspace: Yes",
  "AlwaysSaveHistory: Default",
  "EnableCodeIndexing: Yes",
  "UseSpacesForTab: Yes",
  "NumSpacesForTab: 2",
  "Encoding: UTF-8"
)

writeLines(lines, r_proj_file)

# Render and copy the book ####
quarto_render("index.qmd")

# Copy the book as PDF
file.copy("_book/Data-Literate-with-R.pdf", "output/book")

# Create ZIP file ####
setwd(here("output"))

file.remove("../data-literate-with-R.zip")

# Zip all
zip("../data-literate-with-R.zip", 
    c("data-literate-with-R.Rproj",
      "book/",
      "data/",
      "docs/",
      "scripts/",
      "slides/"
      ))

setwd(here())

# Copy ZIP to book for deployment
file.copy("data-literate-with-R.zip", "_book/")
