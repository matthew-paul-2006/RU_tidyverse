
# pathToPres <- "/Users/tcarroll/Projects/Software/teaching/tidyR"
# wkdDir <- "/Users/tcarroll/Projects/Software/teaching/tidyR/"

#env_default <- parent.env
# cleanSearch <- function(env_defaults) {
#   currentList <- search()  
#   deletes <- setdiff(currentList, env_defaults)
#   sapply(deletes,function(x){detach(x, character.only = TRUE)})      
# }

pathToPres <- "/Users/mattpaul/Documents/Box Sync/RU/Teaching/RU_side/RU_tidyverse/tidyR/"
wkdDir <- "/Users/mattpaul/Documents/Box Sync/RU/Teaching/RU_side/RU_tidyverse/tidyR/"


setwd(wkdDir)
dir.create(file.path(wkdDir,"presentations","slides","imgs"),recursive = TRUE,showWarnings = FALSE)
dir.create(file.path(wkdDir,"presentations","singlepage","imgs"),recursive = TRUE,showWarnings = FALSE)
dir.create(file.path(wkdDir,"presentations","slides","customCSS"),recursive = TRUE,showWarnings = FALSE)
dir.create(file.path(wkdDir,"presentations","r_code"),recursive = TRUE,showWarnings = FALSE)

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
  #if(length(sessionInfo()$otherPkgs)>0){
  #invisible(lapply(paste0('package:', names(sessionInfo()$otherPkgs)), detach, character.only=TRUE))}
  #cleanSearch(env_defaults)
  library(rmarkdown)
  render(file.path(wkdDir,"presentations","slides",basename(f)),output_format = "xaringan::moon_reader",knit_root_dir = getwd())
  #callr::r(func=rmarkdown::render(file.path(wkdDir,"presentations","slides",basename(f)),output_format = "xaringan::moon_reader",knit_root_dir = getwd()), args=list(wkdDir,f), show = TRUE)
  #invisible(lapply(paste0('package:', names(sessionInfo()$otherPkgs)), detach, character.only=TRUE))
  #cleanSearch(env_defaults)
  library(rmarkdown)
  tx  <- readLines(f)
  idx <- grep('---',tx)[-c(1,2)]
  tx[idx]  <- gsub(pattern = "---", replace = "", x = tx[idx])
  writeLines(tx, con=file.path(wkdDir,"presentations","singlepage",basename(f)))
  render(file.path(wkdDir,"presentations","singlepage",basename(f)),output_format = "html_document",output_dir = file.path(wkdDir,"presentations","singlepage"),knit_root_dir = getwd())#, envir = new.env())
  #callr::r(func=rmarkdown::render(file.path(wkdDir,"presentations","singlepage",basename(f)),output_format = "html_document",output_dir = file.path(wkdDir,"presentations","singlepage"),knit_root_dir = getwd()))
  #cleanSearch(env_defaults)
  knitr::purl(file.path(wkdDir,"presentations","singlepage",basename(f)),str_sub(file.path(wkdDir,"presentations","r_code",basename(f)),1,(nchar(file.path(wkdDir,"presentations","r_code",basename(f)))-2)))
}


unlink(file.path(wkdDir,"presentations/*/*.Rmd"))

exToCompile <- dir(file.path(pathToPres,"exercises"),pattern="*.Rmd$",full.names = T)
for(f in exToCompile){
  library(rmarkdown)
  render(f, output_format = "html_document", output_dir = file.path(pathToPres,"exercises"), knit_root_dir = getwd())
}

ansToCompile <- dir(file.path(pathToPres,"answers"),pattern="*.Rmd$",full.names = T)
for(f in ansToCompile){
  library(rmarkdown)
  render(f, output_format = "html_document", output_dir = file.path(pathToPres,"answers"), knit_root_dir = getwd())
  knitr::purl(f,str_sub(f,1,nchar(f)-2))
}




