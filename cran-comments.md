## Resubmission

This is a resubmission. In this version I have 2 changes,
the former requested by CRAN and the latter by myself:

* Write package name in single quotes (e.g. 'flextable') in Title and Description.
* Following minor refactorings to improve robustness of codes
    * Use `tidyselect::everything` instead of `dplyr::everything`
    * Specify `stringAsFactors = FALSE` when calling `data.frame`
    * `shQuote`d Pandoc's path 

## Test environments
* local
  * Debian GNU/Linux 10 (buster), R 3.6.2
* rhub
  * Windows Server 2008 R2 SP1, R-devel, 32/64 bit
  *	Ubuntu Linux 16.04 LTS, R-release, GCC
  * Fedora Linux, R-devel, clang, gfortran

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## revdepcheck results

There are currently no downstream dependencies for this package
