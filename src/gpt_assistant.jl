"""
 Makes working with an Assistant from the OpenAI API


 - Assistants can call OpenAI's models with specific instructions to tune their personality and capabilities.
 - Assistants can access multiple tools in parallel. These can be both OpenAI-hosted tools — like code_interpreter and file_search — or tools you build / host (via function calling).
 - Assistants can access persistent Threads. Threads simplify AI application development by storing message history and truncating it when the conversation gets too long for the model’s context length. You create a Thread once, and simply append Messages to it as your users reply.
 - Assistants can access files in several formats — either as part of their creation or as part of Threads between Assistants and users. When using tools, Assistants can also create files (e.g., images, spreadsheets, etc) and cite files they reference in the Messages they create.


 @description
 `gpt_assistant()` sends a single [completion request](https://beta.openai.com/docs/api-reference/completions) to the Open AI GPT-3 API.
 @details For a general guide on the completion requests, see [https://beta.openai.com/docs/guides/completion](https://beta.openai.com/docs/guides/completion). This function provides you with an R wrapper to send requests with the full range of request parameters as detailed on [https://beta.openai.com/docs/api-reference/completions](https://beta.openai.com/docs/api-reference/completions) and reproduced below.


*Parameters*

   - `prompt_input`: character that contains the prompt to the GPT-3 request
   - `model`: a character vector that indicates the [model](https://beta.openai.com/docs/models/gpt-3) to use; one of "gpt-3.5-turbo" (default), "text-davinci-003",  "text-davinci-002", "text-davinci-001", "text-curie-001", "text-babbage-001" or "text-ada-001"
   - `output_type`: character determining the output provided: "complete" (default), "text" or "meta"
   - `suffix`: character (default: NULL) (from the official API documentation:The suffix that comes after a completion of inserted text_)
   - `max_tokens`: numeric (default: 100) indicating the maximum number of tokens that the completion request should return (from the official API documentation:The maximum number of tokens to generate in the completion. The token count of your prompt plus max_tokens cannot exceed the model"s context length. Most models have a context length of 2048 tokens (except for the newest models, which support 4096)_)
   - `temperature`: numeric (default: 0.9) specifying the sampling strategy of the possible completions (from the official API documentation:What sampling temperature to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer. We generally recommend altering this or top_p but not both._)
   - `top_p`: numeric (default: 1) specifying sampling strategy as an alternative to the temperature sampling (from the official API documentation:An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or temperature but not both._)
   - `n` numeric: (default: 1) specifying the number of completions per request (from the official API documentation:How many completions to generate for each prompt. **Note: Because this parameter generates many completions, it can quickly consume your token quota.** Use carefully and ensure that you have reasonable settings for max_tokens and stop._)
   - `logprobs`: numeric (default: NULL) (from the official API documentation:Include the log probabilities on the logprobs most likely tokens, as well the chosen tokens. For example, if logprobs is 5, the API will return a list of the 5 most likely tokens. The API will always return the logprob of the sampled token, so there may be up to logprobs+1 elements in the response. The maximum value for logprobs is 5. If you need more than this, please go to [https://help.openai.com/en/](https://help.openai.com/en/) and describe your use case._)
   - `stop`: character or character vector (default: NULL) that specifies after which character value when the completion should end (from the official API documentation:Up to 4 sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence._)
   - `presence_penalty`: numeric (default: 0) between -2.00  and +2.00 to determine the penalisation of repetitiveness if a token already exists (from the official API documentation:Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model"s likelihood to talk about new topics._). See also: [https://beta.openai.com/docs/api-reference/parameter-details](https://beta.openai.com/docs/api-reference/parameter-details)
   - `frequency_penalty`: numeric (default: 0) between -2.00  and +2.00 to determine the penalisation of repetitiveness based on the frequency of a token in the text already (from the official API documentation:Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model"s likelihood to repeat the same line verbatim._). See also: [https://beta.openai.com/docs/api-reference/parameter-details](https://beta.openai.com/docs/api-reference/parameter-details)
   - `verbose`: print model to output

 Parameters not included/supported:
 
   - `logit_bias`: [https://beta.openai.com/docs/api-reference/completions/create#completions/create-logit_bias](https://beta.openai.com/docs/api-reference/completions/create#completions/create-logit_bias)
   - `echo`: [https://beta.openai.com/docs/api-reference/completions/create#completions/create-echo](https://beta.openai.com/docs/api-reference/completions/create#completions/create-echo)
   - `stream`: [https://beta.openai.com/docs/api-reference/completions/create#completions/create-stream](https://beta.openai.com/docs/api-reference/completions/create#completions/create-stream)


 A tuple with two DataFrames (if `output_type` is the default "complete"): 
 
   - [1] contains the data table with the columns `n` (= the mo. of `n` responses requested), `prompt` (= the prompt that was sent), and `gpt` (= the completion as returned from the GPT-3 model). 
   - [2] contains the meta information of the request, including the request id, the parameters of the request and the token usage of the prompt (`tok_usage_prompt`), the completion (`tok_usage_completion`) and the total usage (`tok_usage_total`).

 If `output_type` is "text", only the DataFrames in slot [1] is returned.

 If `output_type` is "meta", only the DataFrames in slot [2] is returned.


 _Examples_
 # First authenticate with your API key via `gpt_authenticate("pathtokey")`

 # Once authenticated:

 ## Create an assistant
 name = "Admin"
 instructions = "Assist in a variety of tasks including scheduling, statistical coding, and brainstorming."
 asst = create_gpt_assistant(name, instructions;
                      tools = ["code_interpreter", "file_search"])
  asst2 = create_gpt_assistant("Coder", "You are an expert at Julia coding for statistical analysis";
                      tools = ["code_interpreter", "file_search"])
  asst[1]
  asst2[1]
create_gpt_thread()

"""
function create_gpt_assistant(;
    name = "Default",
    instructions = "You do some admin tasks, such as scheduling",
    model = "gpt-4o-mini",
    tools = ["code_interpreter"],
    output_type = "complete",
    verbose = true,
)
    check_api_exists()
    verbose ? println("Using $model") : true

    parameter_list = Dict(
        "name" => name,
        "instructions" => instructions,
        "tools" => maketools(tools),
        "model" => model,
    )

    thisurl = url.assistants
    deletenothingkeys!(parameter_list)

    headers = Dict(
        "Authorization" => "Bearer $api_key",
        "Content-Type" => "application/json",
        "OpenAI-Beta" => "assistants=v2",
    )

    request_base =
        HTTP.request("POST", thisurl, body = JSON.json(parameter_list), headers = headers)
    # request_base.status
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end
    core_output = DataFrame(
        "name" => name,
        "instructions" => instructions,
        "assistantID" => request_content["id"],
    )

    meta_output = makemetadata(request_content, ["id"])

    if output_type == "complete"
        output = (core_output, meta_output)
    elseif output_type == "meta"
        output = meta_output
    elseif output_type == "text"
        output = core_output
    end
    return (output)
end


create_gpt_assistant(n, i; kwargs...) =
    create_gpt_assistant(; name = n, instructions = i, kwargs...);

function list_gpt_assistants(;
    limit = 20,
    order = "desc",
    after = nothing,
    before = nothing,
    output_type = "complete",
    verbose = true,
)
    check_api_exists()
    verbose ? println("Checking for GPT assistants") : true
    thisurl = url.assistants
    query = "?"
    kws = ["limit", "order", "after", "before"]
    ps = [limit, order, after, before]
    for i = 1:length(kws)
        qq = isnothing(ps[i]) ? "" : "&$(kws[i])=$(ps[i])"
        query *= qq
    end
    queryurl = thisurl * query
    headers = Dict(
        "Authorization" => "Bearer $api_key",
        "Content-Type" => "application/json",
        "OpenAI-Beta" => "assistants=v2",
    )
    request_base = HTTP.request("GET", queryurl, headers = headers)
    # request_base.status
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end
    #
    core_output = DataFrame(request_content["data"])

    meta_output = makemetadata(request_content, ["data"])

    if output_type == "complete"
        output = (core_output, meta_output)
    elseif output_type == "meta"
        output = meta_output
    elseif output_type == "text"
        output = core_output
    end
    return (output)
end

function delete_gpt_assistant(p; output_type = "complete", verbose = true)
    check_api_exists()
    verbose ? println("Deleting GPT assistant $p") : true
    thisurl = url.assistants
    query = "/$p"
    queryurl = thisurl * query
    headers = Dict(
        "Authorization" => "Bearer $api_key",
        "Content-Type" => "application/json",
        "OpenAI-Beta" => "assistants=v2",
    )
    request_base = HTTP.request("DELETE", queryurl, headers = headers)
    # request_base.status
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end
    #
    core_output = DataFrame(request_content)

    meta_output = Dict()

    if output_type == "complete"
        output = (core_output, meta_output)
    elseif output_type == "meta"
        output = meta_output
    elseif output_type == "text"
        output = core_output
    end
    return (output)
end


function create_gpt_thread(; output_type = "complete", verbose = true)
    check_api_exists()
    verbose ? println("Creating thread") : true
    thisurl = url.threads
    headers = Dict(
        "Authorization" => "Bearer $api_key",
        "Content-Type" => "application/json",
        "OpenAI-Beta" => "assistants=v2",
    )

    request_base = HTTP.request("POST", thisurl, body = JSON.json(""), headers = headers)
    # request_base.status
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end
    core_output =
        DataFrame("id" => request_content["id"], "gpt" => request_content["object"])

    meta_output = makemetadata(request_content, ["id", "object"])

    if output_type == "complete"
        output = (core_output, meta_output)
    elseif output_type == "meta"
        output = meta_output
    elseif output_type == "text"
        output = core_output
    end
    return (output)
end

function list_gpt_threads(; output_type = "complete", verbose = true)
    check_api_exists()
    verbose ? println("Creating thread") : true
    thisurl = url.threads
    headers = Dict(
        "Authorization" => "Bearer $api_key",
        "Content-Type" => "application/json",
        "OpenAI-Beta" => "assistants=v2",
    )

    request_base = HTTP.request("GET", thisurl, headers = headers)
    # request_base.status
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end
    core_output =
        DataFrame("id" => request_content["id"], "gpt" => request_content["object"])

    meta_output = makemetadata(request_content, ["id", "object"])

    if output_type == "complete"
        output = (core_output, meta_output)
    elseif output_type == "meta"
        output = meta_output
    elseif output_type == "text"
        output = core_output
    end
    return (output)
end

function get_gpt_thread(t; output_type = "complete", verbose = true)
    check_api_exists()
    verbose ? println("Creating thread") : true
    thisurl = url.threads
    queryurl = thisurl * "/$t"
    headers = Dict(
        "Authorization" => "Bearer $api_key",
        "Content-Type" => "application/json",
        "OpenAI-Beta" => "assistants=v2",
    )

    request_base = HTTP.request("GET", queryurl, body = JSON.json(""), headers = headers)
    # request_base.status
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end
    core_output =
        DataFrame("id" => request_content["id"], "gpt" => request_content["object"])

    meta_output = makemetadata(request_content, ["id", "object"])

    if output_type == "complete"
        output = (core_output, meta_output)
    elseif output_type == "meta"
        output = meta_output
    elseif output_type == "text"
        output = core_output
    end
    return (output)
end

function modify_gpt_thread(
    t;
    tool_resources = nothing,
    output_type = "complete",
    verbose = true,
)
    # not yet finished: need to figure out how to modify tool_resources
    check_api_exists()
    verbose ? println("Creating thread") : true
    thisurl = url.threads
    queryurl = thisurl * "/$t"
    headers = Dict(
        "Authorization" => "Bearer $api_key",
        "Content-Type" => "application/json",
        "OpenAI-Beta" => "assistants=v2",
    )
    tooldict = maketools(tool_resources)

    request_base = HTTP.request("POST", queryurl, body = JSON.json(""), headers = headers)
    # request_base.status
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end

    core_output =
        DataFrame("id" => request_content["id"], "gpt" => request_content["object"])

    meta_output = makemetadata(request_content, ["id", "object"])

    if output_type == "complete"
        output = (core_output, meta_output)
    elseif output_type == "meta"
        output = meta_output
    elseif output_type == "text"
        output = core_output
    end
    return (output)
end


function add_gpt_message(;
    thread_id = "",
    role = "user",
    content = "",
    attachments = nothing,
    output_type = "complete",
    verbose = true,
)
    # not yet finished: need to figure out how to modify tool_resources
    check_api_exists()
    verbose ? println("Adding message to thread:$thread_id") : true
    thisurl = url.threads
    queryurl = thisurl * "/$thread_id/messages"
    headers = Dict(
        "Authorization" => "Bearer $api_key",
        "Content-Type" => "application/json",
        "OpenAI-Beta" => "assistants=v2",
    )

    parameter_list =
        Dict("role" => role, "content" => content, "attachments" => attachments)

    deletenothingkeys!(parameter_list)


    request_base =
        HTTP.request("POST", queryurl, body = JSON.json(parameter_list), headers = headers)
    # request_base.status
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end

    core_output =
        DataFrame("id" => request_content["id"], "gpt" => request_content["object"])

    meta_output = makemetadata(request_content, ["id", "object"])

    if output_type == "complete"
        output = (core_output, meta_output)
    elseif output_type == "meta"
        output = meta_output
    elseif output_type == "text"
        output = core_output
    end
    return (output)
end

function run_gpt_thread(;
    thread_id = "",
    assistant_id = "",
    model = "gpt-4o-mini",
    reasoning_effort = raw"medium",
    instructions = nothing, #over ride instructions on a per-run basis
    additional_instructions = nothing, #over ride instructions on a per-run basis
    tools = nothing, #over ride tools on a per-run basis
    metadata = nothing,
    stream = false,
    temperature = 0.9,
    top_p = 1,
    max_prompt_tokens = nothing,
    max_completion_tokens = 100,
    truncation_strategy = nothing,
    tool_choice = nothing,
    output_type = "complete",
    verbose = true,
)
    # not yet finished: need to figure out how to modify tool_resources
    check_api_exists()
    verbose ? println("Running thread:$thread_id") : true
    thisurl = url.threads
    queryurl = thisurl * "/$thread_id/runs"
    headers = Dict(
        "Authorization" => "Bearer $api_key",
        "Content-Type" => "application/json",
        "OpenAI-Beta" => "assistants=v2",
    )

    messages = [
        Dict("role" => "user", "content" => prompt_input),
        Dict("role" => "developer", "content" => devmessage),
    ]

    parameter_list = Dict(
        "thread_id" => thread_id,
        "assistant_id" => assistant_id,
        "model" => model,
        "reasoning_effort" => reasoning_effort,
        "instructions" => instructions,
        "additional_instructions" => additional_instructions,
        "tools" => maketools(tools),
        "metadata" => metadata,
        "stream" => stream,
        "temperature" => temperature,
        "top_p" => top_p,
        "max_prompt_tokens" => max_prompt_tokens,
        "max_completion_tokens" => max_completion_tokens,
        "truncation_strategy" => truncation_strategy,
        "tool_choice" => tool_choice,
    )

    deletenothingkeys!(parameter_list)
    request_base =
        HTTP.request("POST", queryurl, body = JSON.json(parameter_list), headers = headers)
    # request_base.status
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end

    core_output =
        DataFrame("id" => request_content["id"], "gpt" => request_content["object"])

    meta_output = makemetadata(request_content, ["id", "object"])

    if output_type == "complete"
        output = (core_output, meta_output)
    elseif output_type == "meta"
        output = meta_output
    elseif output_type == "text"
        output = core_output
    end
    return (output)
end

run_gpt_thread(tid, aid; kwargs...) =
    run_gpt_thread(; thread_id = tid, assistant_id = aid, kwargs...)
