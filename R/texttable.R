pandoc_readers = c("native", "json", "markdown", "markdown_strict", "markdown_phpextra", "markdown_github", "commonmark", "textile", "rst", "html", "docbook", "t2t", "docx", "odt", "epub", "opml", "org", "mediawiki", "twiki", "haddock", "latex")

pandoc_extensions = c("xhtml", "html", "htm", "tex", "latex", "ltx", "rst", "org", "lhs", "db", "opml", "wiki", "dokuwiki", "textile", "native", "json", "docx", "t2t", "epub", "odt", "pdf", "doc")

problem_formats = c("latex", "haddock", "odt")

#' Import tables from various text formats
#'
#' Parse tables from various formats into data frames.
#'
#' @param text A file, URL, or character string. Only length 1 inputs are allowed.
#' @param format The format of the input text.  The default will guess from the
#'               file extension of a file or URL, or default to Pandoc-flavored
#'               markdown for input passed as a character string. For allowable
#'               input types, see the
#'               \href{http://pandoc.org/README.html#general-options}{Pandoc manual}.
#' @param trim_leading Should leading whitespace be trimmed from text input?
#' @param ... arguments to pass to \code{\link[rvest]{html_table}} to specify how tables
#'            should be parsed.
#' @return A list of data frames.  Any tables with captions will have the
#'         caption as the list element name.
#' @details \code{texttable} converts the input to HTML via
#'          \href{http://pandoc.org/}{Pandoc} and then imports tables via
#'          \code{\link[rvest]{html_table}}.
#'
#'          Due to issues in pandoc, ODT and DocBook formats do not currently
#'          work.
#' @import rmarkdown xml2 rvest assertthat
#' @export
texttable <- function(text, format = NULL, trim_leading = TRUE, ...) {

  if (length(text) != 1) {
    stop("Only inputs of length 1 are allowed.")
  }

  textfile <- as_file(text, trim_leading)

  extension <- tools::file_ext(textfile)

  if(is.null(format) & extension %in% c("", "md")) {
    format <- "markdown"
  }

  if(extension %in% pandoc_readers && !(extension %in% pandoc_extensions)) {
    format <- extension
  }

  if(!is.null(format) && format %in% problem_formats) {
    warning("Known issues with Pandoc's conversion of ", format, " tables")
  } else if(tools::file_ext(textfile) %in% problem_formats) {
    warning("Known issues with Pandoc's conversion of ", tools::file_ext(text), " tables")
  }

  tmp_html <- tempfile(fileext = ".html")
  rmarkdown::pandoc_convert(input = textfile, to = "html", from = format,
                            output = tmp_html, wd = getwd())
  html <- xml2::read_html(tmp_html)
  html_tables <- xml2::xml_find_all(html, "//table")
  tables <- rvest::html_table(html_tables)
  captions <- vapply(html_tables, function(tab) {
    caption <- xml2::xml_find_all(tab, "caption")
    if(length(caption) == 0) {
      return("")
    } else {
      return(xml2::xml_text(caption))
    }
  }, character(1))
  tables <- rvest::html_table(html_tables, ...)
  names(tables) <- captions
  return(tables)
}

#' @import httr tools
as_file <- function(x, trim_leading) {
  if (file.exists(x)) {
    return(x)
  } else if (!is.null(httr::parse_url(x)$scheme) &&
             identical(try(httr::status_code(httr::HEAD(x)), silent=TRUE), 200L)) {
    extension = tools::file_ext(httr::parse_url(x)$path)
    if (extension != "") extension = paste0(".", extension)
    tmp_text = tempfile(fileext = extension)
    res <- httr::GET(x, write_disk(tmp_text))
    httr::stop_for_status(res)
    return(tmp_text)
  } else {
    if(trim_leading) {
      x = trim_lead(x)
    }
    tmp_text = tempfile()
    cat(x, file = tmp_text)
    return(tmp_text)
  }
}

#' @import stringi
trim_lead <- function(x) {
  paste(stri_trim_left(stri_split_fixed(x, '\n', simplify=TRUE)), collapse='\n')
}