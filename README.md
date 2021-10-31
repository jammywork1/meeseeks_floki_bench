# Meeseeks vs. Floki Performance

A performance comparsion between the Elixir language HTML parsing libraries [Meeseeks](https://github.com/mischov/meeseeks) and [Floki](https://github.com/philss/floki).

Performance benchmarks should always be considered with some skepticism.

Benchmarking is hard to do well, and often - intentionally or not - benchmarks may favor one implementation's strengths over another in a way that makes one look better but doesn't really help users.

For these benchmarks I have tried to focus on potential real-world-type scenarios that people might find helpful, but if performance matters consider benchmarking the two for your particular problem.

### Config

Floki is benchmarked using the `fast_html` parser.

Performance characteristics are different for the `mochiweb_html` parser, but I strongly recommend always using the `fast_html` parser unless you're sure malformed HTML won't be a problem.

### Setup

Your OS is (probably) constantly changing your processor speed (to save energy and reduce heat), which leads to inconsistent results when benchmarking.

Before running benchmarks, set processors to some fixed speed. For Debian instructions on how to do this, see [here](https://wiki.debian.org/HowTo/CpuFrequencyScaling).

Thanks to [this article](https://medium.com/learn-elixir/speed-up-data-access-in-elixir-842617030514) for pointing this out.

## The "Wiki Links" Benchmark

The scenario tested by "Wiki Links" is simple: select every link from a particular Wikipedia article to other Wikipedia articles.

This scenario is intended to mimic a simple crawler that is looking on each page for more links to follow.

The test data used is 99Kb and parses to ~2,700 nodes.

For XPath, I test both a naive solution that is closely related to the CSS solution and a more optimized version that avoids an early filter.

```
$ MIX_ENV=prod mix compile
$ MIX_ENV=prod mix run bench/wiki_links.exs
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
Number of Available Cores: 12
Available memory: 32 GB
Elixir 1.12.3
Erlang 24.1.2

Benchmark suite executing with the following configuration:
warmup: 3 s
time: 9 s
memory time: 3 s
parallel: 1
inputs: none specified
Estimated total run time: 1 min

Benchmarking Floki CSS...
Benchmarking Meeseeks CSS...
Benchmarking Meeseeks XPath naive...
Benchmarking Meeseeks XPath optimized...

Name                               ips        average  deviation         median         99th %
Floki CSS                       131.41        7.61 ms    ±11.23%        7.43 ms       10.81 ms
Meeseeks CSS                    115.80        8.64 ms     ±4.57%        8.52 ms        9.98 ms
Meeseeks XPath optimized        110.59        9.04 ms     ±4.03%        8.94 ms       10.30 ms
Meeseeks XPath naive             89.71       11.15 ms     ±6.01%       10.91 ms       13.19 ms

Comparison: 
Floki CSS                       131.41
Meeseeks CSS                    115.80 - 1.13x slower +1.03 ms
Meeseeks XPath optimized        110.59 - 1.19x slower +1.43 ms
Meeseeks XPath naive             89.71 - 1.46x slower +3.54 ms

Memory usage statistics:

Name                        Memory usage
Floki CSS                        2.95 MB
Meeseeks CSS                     0.77 MB - 0.26x memory usage -2.17947 MB
Meeseeks XPath optimized         1.09 MB - 0.37x memory usage -1.85918 MB
Meeseeks XPath naive             2.16 MB - 0.73x memory usage -0.79591 MB

**All measurements for memory usage were the same**
```

If you're going to be building a simple crawler where all you care about is searching a page for links, either Meeseeks or Floki will perform similarly (though Meeseeks will probably use less memory).

[Implementation](https://github.com/mischov/meeseeks_floki_bench/blob/master/lib/meeseeks_floki_bench/wiki_links.ex)

## The "Trending JS" Benchmark

"Trending JS" represents a simple scenario where, overwhelmed by the churn in the JS ecosystem, you want a quick way to check what JS libraries are trending on Gibhub today, returning the name, total stars, and stars today for each.

This scenario mimics the use case of selecting a list of items from some HTML page and then extracting data from each of these items.

The test data used is 349Kb and parses to ~6,900 nodes.

```
$ MIX_ENV=prod mix compile
$ MIX_ENV=prod mix run bench/trending_js.exs
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
Number of Available Cores: 12
Available memory: 32 GB
Elixir 1.12.3
Erlang 24.1.2

Benchmark suite executing with the following configuration:
warmup: 3 s
time: 9 s
memory time: 3 s
parallel: 1
inputs: none specified
Estimated total run time: 45 s

Benchmarking Floki CSS...
Benchmarking Meeseeks CSS ...
Benchmarking Meeseeks XPath...

Name                     ips        average  deviation         median         99th %
Meeseeks CSS           33.24       30.08 ms     ±4.60%       29.82 ms       34.56 ms
Meeseeks XPath         28.08       35.61 ms     ±3.69%       35.36 ms       39.65 ms
Floki CSS              10.82       92.41 ms    ±21.73%       97.75 ms      110.62 ms

Comparison: 
Meeseeks CSS           33.24
Meeseeks XPath         28.08 - 1.18x slower +5.52 ms
Floki CSS              10.82 - 3.07x slower +62.33 ms

Memory usage statistics:

Name              Memory usage
Meeseeks CSS           3.66 MB
Meeseeks XPath         6.57 MB - 1.80x memory usage +2.91 MB
Floki CSS             15.23 MB - 4.16x memory usage +11.57 MB

**All measurements for memory usage were the same**
```

Meeseeks avoids some converting between data formats that Floki does, so the Meeseeks implementations tend to come out ahead of Floki in this benchmark.

[Implementation](https://github.com/mischov/meeseeks_floki_bench/blob/master/lib/meeseeks_floki_bench/trending_js.ex)

## Further Benchmarks

If you have an idea for a useful, real-world inspired benchmark, please open an issue.

Contributions are welcome.
