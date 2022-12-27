"""
Placeholder for a short summary about GPT3.
"""
module GPT3

##############################################################################
##
## Dependencies
##
##############################################################################


using DataFrames, HTTP, JSON
import DataFrames: DataFrame


##############################################################################
##
## Exported methods and types
##
##############################################################################

export  gpt3_single_embedding,
        gpt3_single_completion,
        gpt3_single_image,
        gpt3_single_image_edit,
        gpt3_single_image_variations,
        gpt3_completions,
        gpt3_embeddings,
        gpt3_authenticate,
        check_apikey_form,
        deletenothingkeys!,
        check_api_exists
        

##############################################################################
##
## Load files
##
##############################################################################
include("authenticate.jl")
include("base_urls.jl")
include("gpt3_completions.jl")
include("gpt3_embeddings.jl")
include("gpt3_single_completion.jl")
include("gpt3_single_embedding.jl")
include("gpt3_single_image_generation.jl")
include("gpt3_single_image_edit.jl")
include("gpt3_single_image_variations.jl")
#include("test_completion.jl")
include("utils.jl")

end # module