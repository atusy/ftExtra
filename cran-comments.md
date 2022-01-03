

## Test environments

- Local
  - Debian GNU/Linux 10 (buster), R 4.0
- GitHub Actions
  - {os: macOS-latest,   pandoc: '2.11.2', r: 'release'}
  - {os: windows-latest, pandoc: '2.11.2', r: 'release'}
  - {os: windows-latest, pandoc: '2.11.2', r: '3.6'}
  - {os: ubuntu-16.04,   pandoc: '2.11.2', r: 'devel'}
  - {os: ubuntu-16.04,   pandoc: '2.7.3' , r: 'devel'}
  - {os: ubuntu-16.04,   pandoc: '2.0.6' , r: 'devel'}
  - {os: ubuntu-16.04,   pandoc: '2.11.2', r: 'release'}
  - {os: ubuntu-16.04,   pandoc: '2.11.2', r: 'oldrel'}
  - {os: ubuntu-16.04,   pandoc: '2.11.2', r: '3.5'}
  - {os: ubuntu-16.04,   pandoc: '2.11.2', r: '3.4'}
  - {os: ubuntu-16.04,   pandoc: '2.11.2', r: '3.3'}
- rhub
  -  Debian Linux, R-devel, clang, ISO-8859-15 locale
  -  Debian Linux, R-devel, GCC
  -  Debian Linux, R-devel, GCC, no long double
  -  Debian Linux, R-patched, GCC
  -  Debian Linux, R-release, GCC
  -  Fedora Linux, R-devel, clang, gfortran
  -  Fedora Linux, R-devel, GCC
  -  Debian Linux, R-devel, GCC ASAN/UBSAN
  -  macOS 10.13.6 High Sierra, R-release, brew
  -  macOS 10.13.6 High Sierra, R-release, CRAN's setup
  -  Apple Silicon (M1), macOS 11.6 Big Sur, R-release
  -  Oracle Solaris 10, x86, 32 bit, R-release
  -  Oracle Solaris 10, x86, 32 bit, R release, Oracle Developer Studio 12.6
  -  Ubuntu Linux 20.04.1 LTS, R-devel, GCC
  -  Ubuntu Linux 20.04.1 LTS, R-release, GCC
  -  Ubuntu Linux 20.04.1 LTS, R-devel with rchk
  -  Windows Server 2022, R-devel, 64 bit
  -  Windows Server 2008 R2 SP1, R-oldrel, 32/64 bit
  -  Windows Server 2008 R2 SP1, R-patched, 32/64 bit
  -  Windows Server 2008 R2 SP1, R-release, 32/64 bit
- win builder
  - R-devel
  - R-release

## R CMD check results

0 errors | 0 warnings | 0 note

## revdepcheck results

We checked 1 reverse dependencies (0 from CRAN + 1 from BioConductor), comparing R CMD check results across CRAN and dev versions of this package.

 - We saw 0 new problems
 - We failed to check 0 packages
