"""
Placeholder for a short summary about gpt.
"""
module GPT

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

export  #gpt_single_embedding,
        chatgpt,
        dalle,
        listgptmodels,
        gpt_single_completion,
        gpt_single_image,
        gpt_single_image_edit,
        gpt_single_image_variations,
        #gpt_completions,
        #gpt_embeddings,
        gpt_authenticate,
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
#include("gpt_completions.jl")
#include("gpt_embeddings.jl")
include("gpt_single_completion.jl")
#include("gpt_single_embedding.jl")
include("gpt_single_image_generation.jl")
include("gpt_single_image_edit.jl")
include("gpt_single_image_variations.jl")
#include("test_completion.jl")
include("utils.jl")

end # module