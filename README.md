# GPT.jl

<!-- Tidyverse lifecycle badges, see https://www.tidyverse.org/lifecycle/ Uncomment or delete as needed. -->
![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![build](https://github.com/alexpkeil1/gpt.jl/workflows/CI/badge.svg)](https://github.com/alexpkeil1/GPT.jl/actions?query=workflow%3ACI)
<!-- travis-ci.com badge, uncomment or delete as needed, depending on whether you are using that service. -->
<!-- [![Build Status](https://travis-ci.com/alexpkeil1/gpt.jl.svg?branch=master)](https://travis-ci.com/alexpkeil1/gpt.jl) -->
<!-- Coverage badge on codecov.io, which is used by default. -->
[![codecov.io](http://codecov.io/github/alexpkeil1/gpt.jl/coverage.svg?branch=master)](http://codecov.io/github/alexpkeil1/GPT.jl?branch=master)
<!-- Documentation -- uncomment or delete as needed -->
<!--
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://alexpkeil1.github.io/gpt.jl/stable)
[![Documentation](https://img.shields.io/badge/docs-master-blue.svg)](https://alexpkeil1.github.io/gpt.jl/dev)
-->

Access the [OpenAI API](https://platform.openai.com/docs/overview) from Julia. This started out as a line-for-line port from the R package [rgpt](https://github.com/ben-aaron188/rgpt) from [ben-aaron188](https://github.com/ben-aaron188)[^1]. I have added new functionality to allow for additional connections to the API which have been tested for basic functionality as of Feb-2025. Work on this module is ongoing, but development only occurs when I personally need to use something from this API, which is rare. Pull requests are welcome to address bugs. Also consider:

  - [OpenAI.jl](https://github.com/JuliaML/OpenAI.jl)

  - [GenGPT3.jl](https://github.com/probcomp/GenGPT3.jl)


[^1]: Kleinberg, B. (2022). rgpt: Making requests from R to the GPT-3 API (Version 0.3) [Computer software]. https://doi.org/10.5281/zenodo.7327667