# see documentation at https://juliadocs.github.io/Documenter.jl/stable/

using Documenter, GPT

makedocs(
    modules = [GPT],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Alex Keil",
    sitename = "GPT.jl",
    pages = Any["index.md"],
    # strict = true,
     clean = true
    # checkdocs = :exports,
)

# Some setup is needed for documentation deployment, see “Hosting Documentation” and
# deploydocs() in the Documenter manual for more information.
deploydocs(
    repo = "github.com/alexpkeil1/GPT.jl.git",
    push_preview = true,
    deploy_config = Documenter.GitHubActions("push", "github.com/alexpkeil1/GPT.jl.git", "main")
)
