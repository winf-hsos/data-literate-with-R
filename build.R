library(quarto)
library(here)

quarto_preview_stop()

wd <- getwd()

# Build parameters
quiet <- FALSE
render_docs = TRUE

# Create output directories ####
unlink("output", recursive = TRUE)
dir.create("output")

dir.create("output/data")
dir.create("output/scripts")
dir.create("output/scripts/basics")
dir.create("output/scripts/data-loading")
dir.create("output/scripts/data-transformation")
dir.create("output/scripts/data-visualization")

# Docs output folder
dir.create("output/docs")
dir.create("output/docs/basics")
dir.create("output/docs/data-loading")
dir.create("output/docs/data-transformation")
dir.create("output/docs/data-visualization")

# Exercises output folder
dir.create("output/exercises")
dir.create("output/exercises/basics")
dir.create("output/exercises/data-loading")
dir.create("output/exercises/data-transformation")
dir.create("output/exercises/data-visualization")

dir.create("output/book")
dir.create("output/slides")

print("Created output directories...")

# Render single documents to PDF
if(render_docs == TRUE) {
  
  print("Start rendering PDF documents...")
  
  qmd_list <- list.files("documents", ".qmd", full.names = TRUE, recursive = TRUE)
  quarto_render(qmd_list, output_format = "pdf", quiet = quiet)
  
  print("Finished rendering PDF documents...")
}

# Copy .pdf files
pdf_list <- list.files("documents", ".pdf", full.names = TRUE, recursive = TRUE)
pdf_dest_list <- gsub("documents/", "output/docs/", pdf_list)
file.copy(pdf_list, pdf_dest_list, overwrite = TRUE)
print("Copied PDF documents...")

# Render exercises to PDF
qmd_list <- list.files("exercises", ".qmd", full.names = TRUE, recursive = TRUE)
quarto_render(qmd_list, output_format = "pdf", quiet = quiet)

# Copy .pdf files
pdf_list <- list.files("exercises", ".pdf", full.names = TRUE, recursive = TRUE)
pdf_dest_list <- gsub("exercises/", "output/exercises/", pdf_list)
file.copy(pdf_list, pdf_dest_list, overwrite = TRUE)

print("Rendered and copied exercises...")

# Copy .R files
r_list <- list.files("scripts", ".R", full.names = TRUE, recursive = TRUE)
r_dest_list <- gsub("scripts/", "output/scripts/", r_list)
file.copy(r_list, r_dest_list, overwrite = TRUE)

# Copy the data files #### 
data_list <- list.files("data", ".csv", full.names = TRUE, recursive = TRUE)
data_list <- c(data_list, list.files("data", ".xlsx", full.names = TRUE, recursive = TRUE))
data_list <- c(data_list, list.files("data", ".rds", full.names = TRUE, recursive = TRUE))
file.copy(data_list, "output/data", overwrite = TRUE)

print("Copied data files...")

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

print("Created R-project file...")

# Render and copy the book ####
quarto_render("index.qmd", quiet = quiet)

# Copy the book as PDF
file.copy("_book/Data-Literate-with-R.pdf", "output/book")

print("Rendered and copied book as PDF...")

# Download and save Google Slides ####
library(httr)

#install.packages("pdftools")
library(pdftools)

#url <- "https://docs.google.com/presentation/d/1HLRd41yePsS4DDA1bHMLoqv3fdHkOH4lIG2SpPFH1ME/export?format=pdf"
#slidedeck <- GET(url, write_disk("slides/test.pdf", overwrite=TRUE))
#slidedeck


library(yaml)
slides_yaml <- read_yaml("slides/slides.yml")

# Remove all slides
unlink("slides/*.pdf")

for (i in 1:length(slides_yaml$slides)) { 

  # Save temporary
  url <- paste0("https://docs.google.com/presentation/d/", slides_yaml$slides[i], "/export?format=pdf")
  
  print(url)
  
  slidedeck <- GET(url, write_disk("slides/tmp.pdf", overwrite=TRUE))

  # Rename
  slide_infos <- pdf_info("slides/tmp.pdf")
  slide_title <- slide_infos$keys$Title
  
  file.rename("slides/tmp.pdf", paste0("slides/", slide_title, ".pdf"))
 
}

# Copy the slides pdf files
slides_list <- list.files("slides", ".pdf", full.names = TRUE, recursive = TRUE)
file.copy(slides_list, "output/slides", overwrite = TRUE)

print("Downloaded and copied Google Slides as PDF...")

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
      "exercises/",
      "slides/"
      ))

print("Zipped all content...")

setwd(here())

# Copy ZIP to book for deployment
file.copy("data-literate-with-R.zip", "_book/", overwrite = TRUE)
