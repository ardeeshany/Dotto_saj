create_posts_json <- function(base_url = "https://datamotto.com") {

  split_path <- function(x) if (dirname(x)==x) x else c(basename(x),split_path(dirname(x)))
  path_posts <- list.dirs(here::here("_posts"), recursive = F)
  all_metadata <- rep(list(NA), length(path_posts))
  for(i in 1:length(path_posts)){
    rmd_path <- glue::glue("{path_posts[i]}/{list.files(path = path_posts[i],pattern = '*.Rmd$')}")
    names(all_metadata)[i] <- gsub(pattern = "\\.Rmd$", "", basename(rmd_path))
    all_metadata[[i]] <- rmarkdown::yaml_front_matter(rmd_path)
    cover_image_url <- ifelse(!is.null(all_metadata[[i]]$preview),
                              ifelse(length(grep(pattern = "^http|^www", x = all_metadata[[i]]$preview, ignore.case = T)) != 0,
                                     all_metadata[[i]]$preview,
                                     glue::glue("{base_url}/posts/{split_path(rmd_path)[2]}/{all_metadata[[i]]$preview}")),
                              NA)
    all_metadata[[i]] <- c(all_metadata[[i]], cover_image_url = cover_image_url)
  }

  exportJson <- RJSONIO::toJSON(all_metadata, asIs = FALSE)
  write(exportJson, here::here("posts.json"))
} 
