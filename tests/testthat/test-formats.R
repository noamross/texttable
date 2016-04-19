

# Test all the file types that pandoc lists as inputs
test_files = list.files(pattern = "table.*[^R]$")

test_files = test_files[-grep("(odt|latex|haddock)", test_files)]

cat("\nPandoc version:", as.character(rmarkdown::pandoc_version()), "\n\n")

context("Format checking")
for (file_name in test_files) {
  file_type = tools::file_ext(file_name)
  imported = texttable(file_name)
  test_that(paste("Importing works from", file_type, "format"), expect_true(is.list(imported)))
  test_that(paste(file_type, "format gives list of length >= 1"), expect_true(length(imported) >= 1))
  test_that(paste("All components of list are data frames for ", file_type), expect_true(all(sapply(imported, is.data.frame))))
}

context("Import type checking")

test_that("Importing works from a URL", {
  imported = texttable("https://raw.githubusercontent.com/jgm/pandoc/master/tests/tables.markdown")
  expect_true(is.list(imported))
  expect_true(length(imported) >= 1)
  expect_true(all(sapply(imported, is.data.frame)))
})

test_that("Importing works from character", {
  imported = texttable("
| Right | Left | Center |
|------:|:-----|:------:|
|12|12|12|
|123|123|123|
|1|1|1|

|       |      |        |
|------:|:-----|:------:|
|12|12|12|
|123|123|123|
|1|1|1|
")
  expect_true(is.list(imported))
  expect_true(length(imported) >= 1)
  expect_true(all(sapply(imported, is.data.frame)))
})


test_that("Importing works from character with leading whitespace", {
 sample_text =  "
                       | Right | Left | Center |
                       |------:|:-----|:------:|
                       |12|12|12|
                       |123|123|123|
                       |1|1|1|

                       |       |      |        |
                       |------:|:-----|:------:|
                       |12|12|12|
                       |123|123|123|
                       |1|1|1|
                       "
 imported = texttable(sample_text)
  expect_true(is.list(imported))
  expect_true(length(imported) >= 1)
  expect_true(all(sapply(imported, is.data.frame)))
})
