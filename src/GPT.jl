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

export  # convenience calls ("API")
        chatgpt,
        dalle,
        # underlying calls
        gpt_single_completion,
        gpt_single_image,
        gpt_single_image_edit,
        gpt_single_image_variations,        
        # assistants
        create_gpt_assistant,
        create_gpt_thread,
        add_gpt_message,
        get_gpt_thread,
        #list_gpt_threads,  # needs to be run in browser with persistent session      
        gptupload,
        list_gpt_assistants,
        delete_gpt_assistant,
        run_gpt_thread,
        retrieve_gpt_run,
        retrieve_gpt_thread,
        # info
        listgptmodels,
        gptmodelinfo,
        # Utils
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
include("gpt_reasoning.jl")
include("gpt_assistant.jl")
#include("gpt_single_embedding.jl")
include("gpt_single_image_generation.jl")
include("gpt_single_image_edit.jl")
include("gpt_single_image_variations.jl")
#include("test_completion.jl")
include("utils.jl")

end # module