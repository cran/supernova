
# Common --------------------------------------------------------------------------------------

test_that("not specifying which term to break down will break down all categorical terms", {
  fit <- lm(mpg ~ factor(am) * factor(cyl), data = mtcars)
  cat_terms <- frm_terms(fit)
  expect_named(pairwise(fit, "Tukey"), cat_terms)
  expect_named(pairwise(fit, "none"), cat_terms)
})

test_that("you can specify the specific term you want to analyze", {
  fit <- lm(mpg ~ factor(am) * factor(cyl), data = mtcars)
  expect_named(pairwise(fit, term = "factor(am):factor(cyl)"), "factor(am):factor(cyl)")
})

test_that("there is an informative error if you try to select a non-existent term", {
  fit <- lm(mpg ~ factor(am) * factor(cyl), data = mtcars)
  expect_snapshot_error(pairwise(fit, "does-not-exist"))
})

test_that("it can handle models with data names that mask function name", {
  data <- vctrs::vec_c(
    tibble::tibble(group = "A", value = rnorm(31)),
    tibble::tibble(group = "B", value = rnorm(30))
  )
  fitted <- lm(value ~ group, data = data)
  expect_error(pairwise(fitted), NA)
})

test_that("it can take a factor defined in the formula", {
  fitted <- lm(mpg ~ factor(cyl), data = mtcars)
  expect_named(pairwise(fitted), "factor(cyl)")
})

test_that("there are no errors with balanced data", {
  # one of the underlying functions returns a single value for n when the counts are balanced
  data <- vctrs::vec_c(
    tibble::tibble(group_1 = "A", group_2 = rep(1:2, each = 15), value = rnorm(30)),
    tibble::tibble(group_1 = "B", group_2 = rep(1:2, each = 15), value = rnorm(30))
  )
  fitted <- lm(value ~ group_1 * group_2, data = data)
  expect_error(pairwise(fitted), NA)
})


# Tukey ---------------------------------------------------------------------------------------

test_that("pairwise wraps pairwise_tukey", {
  fit <- lm(mpg ~ factor(am), data = mtcars)
  expect_equal(pairwise(fit, "Tukey"), pairwise_tukey(fit))
})

test_that("pairwise_tukey tests have family-wise error-rate at alpha rate", {
  fit <- lm(mpg ~ factor(cyl) * factor(am), data = mtcars)
  actual <- pairwise_tukey(fit, alpha = .01)
  expect_equal(attr(actual[[1]], "fwer"), .01)
  expect_equal(attr(actual[[2]], "fwer"), .01)
  expect_equal(attr(actual[[3]], "fwer"), .01)
})

test_that("pairwise_tukey outputs correct values for diff, lower, upper, and p", {
  fit <- lm(mpg ~ factor(cyl) * factor(am), data = mtcars)

  actual <- pairwise_tukey(fit)[[1]][, c("diff", "lower", "upper", "p_adj")]
  actual <- purrr::modify(actual, as.double)
  expected <- as.data.frame(TukeyHSD(aov(fit))[[1]])
  names(expected) <- names(actual)

  ignorable <- c("row.names", "class", "fit", "term", "correction", "n_levels", "alpha", "fwer")
  expect_equal(actual, expected, ignore_attr = ignorable)
})


# t-tests -------------------------------------------------------------------------------------

test_that("pairwise_t matches relevant values from pairwise_tukey", {
  fit <- lm(mpg ~ factor(cyl) * factor(am), data = mtcars)
  expected <- pairwise_tukey(fit)[[1]][, c("group_1", "group_2", "diff", "pooled_se", "df")]
  actual <- pairwise_t(fit)[[1]][, c("group_1", "group_2", "diff", "pooled_se", "df")]
  expect_equal(actual, expected, ignore_attr = c("correction", "fwer"))
})

test_that("uncorrected t-test family-wise error-rate is larger than alpha when more than 2 tests", {
  fit <- lm(mpg ~ factor(cyl) * factor(am), data = mtcars)
  actual <- pairwise_t(fit, alpha = .01, correction = "none")
  expect_gt(attr(actual[[1]], "fwer"), .01)
  expect_gt(attr(actual[[2]], "fwer"), .01)
  expect_gt(attr(actual[[3]], "fwer"), .01)
})


# Plots ---------------------------------------------------------------------------------------

test_that("each type of comparisons object plots well", {
  fit <- lm(mpg ~ factor(cyl), data = mtcars)
  term <- "factor(cyl)"

  tukey <- ggplot2::autoplot(pairwise_tukey(fit))
  vdiffr::expect_doppelganger("Tukey, one variable", tukey[[term]])

  t <- ggplot2::autoplot(pairwise_t(fit))
  vdiffr::expect_doppelganger("t-test, one variable", t[[term]])

  bonf <- ggplot2::autoplot(pairwise_bonferroni(fit))
  vdiffr::expect_doppelganger("Bonferroni, one variable", bonf[[term]])
})

test_that("a separate plot is created for each term in the model", {
  fit <- lm(mpg ~ factor(cyl) * factor(am), data = mtcars)
  plots <- ggplot2::autoplot(pairwise_tukey(fit))
  terms <- labels(stats::terms(fit))
  make_title <- function(x) paste("Multiple plots, term:", x)
  purrr::walk(terms, ~ vdiffr::expect_doppelganger(make_title(.x), plots[[.x]]))
})
