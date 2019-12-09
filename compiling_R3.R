
pathToPres <- "/Users/tcarroll/Projects/Software/teaching/tidyR"
wkdDir <- "/Users/tcarroll/Projects/Software/teaching/tidyR/"
library(rmarkdown)
setwd(wkdDir)
dir.create(file.path(wkdDir,"presentations","slides","imgs"),recursive = TRUE,showWarnings = FALSE)
dir.create(file.path(wkdDir,"presentations","singlepage","imgs"),recursive = TRUE,showWarnings = FALSE)
dir.create(file.path(wkdDir,"presentations","slides","customCSS"),recursive = TRUE,showWarnings = FALSE)


filesToCompile <- dir(file.path(pathToPres,"presRaw"),pattern="*.Rmd$",full.names = T)
# filesToCompile <- filesToCompile[grepl("bioconductor_introduction.Rmd|GenomicIntervals_In_Bioconductor.Rmd|SequencesInBioconductor.Rmd|GenomicScores_In_Bioconductor.Rmd",filesToCompile)]
# filesToCompile <- filesToCompile[grepl("AlignedDataInBioconductor.Rmd",filesToCompile)]


file.copy(dir(file.path(pathToPres,"customCSS"),pattern="*.css$",full.names = T),
          file.path(wkdDir,"presentations","slides",dir(file.path(pathToPres,"customCSS"),pattern="*.css$")))

file.copy(dir(file.path(pathToPres,"imgs"),full.names = T),
          file.path(wkdDir,"presentations","slides","imgs"),recursive=TRUE)
file.copy(dir(file.path(pathToPres,"imgs"),full.names = T),
          file.path(wkdDir,"presentations","singlepage","imgs"),recursive=TRUE)
file.copy(dir(file.path(pathToPres,"presRaw","imgs"),full.names = T),
          file.path(wkdDir,"presentations","slides","imgs"),recursive=TRUE)
file.copy(dir(file.path(pathToPres,"presRaw","imgs"),full.names = T),
          file.path(wkdDir,"presentations","singlepage","imgs"),recursive=TRUE)
#setwd("/Users/tcarroll/Projects/Software/Github/Intro_To_R_1Day_RU/r_course/presentations/slides/")
#xaringan::inf_mr(cast_from = './presentations/slides/')
for(f in filesToCompile){
  file.copy(f,file.path(wkdDir,"presentations","slides",basename(f)),overwrite=TRUE)
  render(file.path(wkdDir,"presentations","slides",basename(f)),output_format = "xaringan::moon_reader",knit_root_dir = getwd())
  invisible(lapply(paste0('package:', names(sessionInfo()$otherPkgs)), detach, character.only=TRUE, unload=TRUE))
  library(rmarkdown)
  render(file.path(wkdDir,"presentations","slides",basename(f)),output_format = "html_document",output_dir = file.path(wkdDir,"presentations","singlepage"),knit_root_dir = getwd())
}

require(rmarkdown)
wkdDir <- "~/Projects/Software/teaching/tidyR/"
filesToCompile <- dir(file.path(wkdDir,"presentations","slides"),pattern="*.Rmd$",full.names = T)

render(file.path(wkdDir,"presentations","slides",basename(f)),output_format = "xaringan::moon_reader",knit_root_dir = getwd())
render(file.path(wkdDir,"presentations","slides",basename(f)),output_format = "html_document",output_dir = file.path(wkdDir,"presentations","singlepage"),knit_root_dir = getwd())
