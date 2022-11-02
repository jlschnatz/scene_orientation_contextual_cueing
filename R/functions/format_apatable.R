format_apatable <- function(.data, .align, .caption, .footnote) {
  out <- kable(
    x = .data,
    format = "latex",
    booktabs = TRUE,
    escape = FALSE,
    longtable = TRUE,
    align = .align,
    caption = .caption
  ) %>% 
    row_spec(row = 0, align = "c") %>%
    kable_styling(full_width = TRUE, font_size = 10, table.envir = "float*") %>% 
    footnote(
      general_title = "\\\\footnotesize{Note.}",
      general = .footnote,
      escape = FALSE,
      threeparttable = TRUE,
      footnote_as_chunk = TRUE
      
    ) 
  return(out)
}
