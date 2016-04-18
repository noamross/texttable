

# Test all the file types that pandoc lists as inputs
test_files = list.files(pattern = "table.*[^R]$")

for (file_name in test_files) {
  test_that(paste("Importing works from", tools::file_ext(file_name), "format"), {
    imported = texttable(file_name)
    expect_true(is.list(imported))
    expect_true(length(imported) >= 1)
    expect_true(all(sapply(imported, is.data.frame)))
  })
}

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
