## Test environments

- Local
  -x86_64-pc-linux-gnu (64-bit), R 4.3
- GitHub Actions
  - {os: macOS-latest,   r: 'release'}
  - {os: windows-latest, r: 'release'}
  - {os: ubuntu-latest,   r: 'devel', http-user-agent: 'release'}
  - {os: ubuntu-latest,   r: 'release'}
- win builder
  - R-devel
  - R-release

## R CMD check results

0 errors | 0 warnings | 0 note

## revdepcheck results

We checked 3 reverse dependencies (0 from CRAN + 3 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
