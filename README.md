# ClamAV PDF and Archive AFL++ Fuzzing Lab

Docker-based AFL++ fuzzing environment for ClamAV, focused on PDF and archive input analysis.

This project is for authorized university cybersecurity research in a controlled lab environment.

## Scope

This repository focuses on:

- preparing PDF and archive fuzzing corpora
- building ClamAV with AFL++ instrumentation
- running reproducible AFL++ fuzzing sessions
- recording fuzzing commands and results
- interpreting whether crashes or hangs were discovered

## Repository Structure

```text
.
├── Dockerfile
├── README.md
├── .gitignore
├── scripts/
│   └── build-clamav-afl.sh
├── corpus/
│   ├── pdf/
│   └── archive/
├── reports/
└── findings/
```
## Environment

Host system used:
```bash
docker --version
```
Example:
Docker version 28.5.2+dfsg4

Inside container:

```bash
afl-clang-fast --version
clang --version
git -C /opt/clamav rev-parse HEAD
git -C /opt/AFLplusplus rev-parse HEAD

```

## Build Docker Image


```bash
docker build -t clamav-pdf-archive-afl .

```
## Start Container

```bash
docker run --rm -it \
  -v "$PWD/corpus:/work/corpus" \
  -v "$PWD/out-pdf:/work/out-pdf" \
  -v "$PWD/out-archive:/work/out-archive" \
  -v "$PWD/findings:/work/findings" \
  -v "$PWD/build-clamav:/work/build-clamav" \
  clamav-pdf-archive-afl

```
## Build Instrumented ClamAV
Inside the container:

```bash
export CC=afl-clang-fast
export CXX=afl-clang-fast++

cd /work/build-clamav

cmake /opt/clamav \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo

ninja clamscan

```
## Verify AFL++ Instrumentation

```bash
afl-showmap -o /dev/null -- /work/build-clamav/clamscan/clamscan /etc/hosts

```
Expected result:
Captured XXXX tuples

## Prepare PDF Corpus

```bash
mkdir -p /work/corpus/pdf

find /opt/clamav -iname "*.pdf" \
  -exec cp {} /work/corpus/pdf/ \;

```
Example corpus files:
clam.pdf
out-of-order.pdf
pdf-stats-test.pdf
uri-and-ref.pdf


## Prepare Archive Corpus

```bash
mkdir -p /work/corpus/archive

find /opt/clamav \
  \( -iname "*.zip" -o -iname "*.7z" -o -iname "*.rar" -o -iname "*.tar" -o -iname "*.gz" -o -iname "*.bz2" \) \
  -exec cp {} /work/corpus/archive/ \;

```
Example archive files:
logos.zip
v1rusv1rus.7z.zip


## Run PDF Fuzzing


```bash
afl-fuzz \
  -i /work/corpus/pdf \
  -o /work/out-pdf \
  -- /work/build-clamav/clamscan/clamscan @@

```

## Run Archive Fuzzing

```bash
afl-fuzz \
  -i /work/corpus/archive \
  -o /work/out-archive \
  -- /work/build-clamav/clamscan/clamscan @@
```
## Stop Fuzzing Safely

Press:
CTRL + C
AFL++ saves session state automatically:
fastresume.bin successfully written

## Result Interpretation


Important AFL++ metrics:

Metric	        Meaning
exec speed	executions per second
corpus count	number of interesting inputs
map density	code coverage estimate
new edges	newly discovered execution paths
saved crashes	unique crashes discovered
saved hangs	unique hangs discovered
stability	instrumentation reliability

Indicators of shallow coverage:

low map density
low corpus growth
very few new edges
AFL state becomes finished

Indicators of possible vulnerability discovery:

saved crashes > 0
saved hangs > 0
reproducible crashing input files


## Safety and Ethics

This project is intended only for:

authorized defensive security research
controlled university lab environments
reproducible vulnerability analysis

Do not:

use unauthorized malware samples
execute fuzzing outputs outside the lab
deploy discovered vulnerabilities offensively.

```bash


```bash

