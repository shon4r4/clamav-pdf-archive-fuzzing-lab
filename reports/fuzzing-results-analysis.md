# ClamAV AFL++ PDF and Archive Fuzzing Results


## Overview

This report summarizes AFL++ fuzzing sessions executed against ClamAV using:

PDF-focused corpus
archive-focused corpus
AFL++ instrumentation
Dockerized reproducible environment


Target binary:
```text
/work/build-clamav/clamscan/clamscan
```

## PDF Fuzzing Run
### Command

```bash
afl-fuzz \
  -i /work/corpus/pdf \
  -o /work/out-pdf \
  -- /work/build-clamav/clamscan/clamscan @@
```

### Observed Results

Metric	        Value
Runtime	        5 minutes 28 seconds
Cycles done	177
Corpus count	5
Total executions	124k
Execution speed	~521 exec/sec
Map density	0.61%
New edges	2
Saved crashes	0
Saved hangs	0
Total timeouts	442
Stability       99.35%


### Interpretation

The PDF fuzzing session executed successfully and AFL++ instrumentation worked correctly.

AFL++ identified limited new execution paths (new edges = 2) and maintained stable instrumentation (99.35% stability).

However, the low map density (0.61%) indicates shallow coverage of ClamAV execution paths.

The fuzzing session did not discover:

confirmed crashes
confirmed hangs
exploitable vulnerabilities

The relatively high timeout count suggests that some malformed PDF mutations caused slower processing paths.

No vulnerability was confirmed.


## Archive Fuzzing Run
### Command

```bash
afl-fuzz \
  -i /work/corpus/archive \
  -o /work/out-archive \
  -- /work/build-clamav/clamscan/clamscan @@
```

### Observed Results

Metric  	Value
Runtime 	5 minutes 49 seconds
Cycles done	386
Corpus count	3
Total executions	279k
Execution speed	~777 exec/sec
Map density	0.61%
New edges	2
Saved crashes	0
Saved hangs	0
Total timeouts	0
Stability	99.35%

### Interpretation

The archive fuzzing session completed successfully.

Compared to the PDF run, the archive-focused corpus achieved:

higher execution speed
fewer timeouts
more completed fuzzing cycles

However, coverage remained shallow.

The repeated map density (0.61%) strongly suggests AFL++ remained within limited high-level execution paths of clamscan.

No crashes or hangs were discovered.

No confirmed vulnerability was identified.

## Technical Analysis

### Successful Outcomes

The project successfully demonstrated:

reproducible Docker-based fuzzing
AFL++ instrumentation of ClamAV
corpus preparation workflows
PDF and archive fuzzing execution
fuzzing session persistence and resumption
reproducible research methodology

### Limitations

The current approach fuzzes the complete clamscan application.

This introduces limitations:

high-level orchestration code dominates execution
parser-specific code receives limited coverage
mutation efficiency remains low
corpus growth remains small

### Main Research Finding

Fuzzing the full clamscan executable with small format-specific corpora produced stable but shallow coverage.

Although AFL++ discovered some new execution edges, no crashes or exploitable conditions were observed.

### Future Improvements

Future work should focus on:

parser-specific harnesses
larger corpora
structured dictionaries
AddressSanitizer builds
libFuzzer harnesses
persistent-mode fuzzing
PDF parser harnessing
archive unpacker harnessing

These techniques would likely increase coverage depth and improve the probability of vulnerability discovery.


## Conclusion

The Dockerized AFL++ ClamAV fuzzing environment functioned successfully and reproducibly.

Both PDF and archive fuzzing sessions executed correctly with stable AFL++ instrumentation.

No confirmed vulnerabilities were discovered during the performed fuzzing runs.

The project successfully established a reusable defensive fuzzing framework suitable for future research and advanced parser-focused fuzzing experiments.
