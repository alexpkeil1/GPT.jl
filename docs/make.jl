# see documentation at https://juliadocs.github.io/Documenter.jl/stable/

using Documenter, GPT3

makedocs(
    modules = [GPT3],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Alex Keil",
    sitename = "GPT3.jl",
    pages = Any["index.md"],
    # strict = true,
     clean = true
    # checkdocs = :exports,
)

# Some setup is needed for documentation deployment, see “Hosting Documentation” and
# deploydocs() in the Documenter manual for more information.
deploydocs(
    repo = "github.com/alexpkeil1/GPT3.jl.git",
    push_preview = true
)
