"""
 Makes a single completion request to the GPT-3 API

 @description
 `gpt_reasoning()` sends a single [completion request](https://beta.openai.com/docs/api-reference/completions) to the Open AI GPT-3 API.
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

 ## Simple request with defaults:
 gpt_reasoning(prompt_input = "How old are you?")

 ## Instruct GPT-3 to write ten research ideas of max. 150 tokens with some controls:
gpt_reasoning(prompt_input = "Write a research idea about using text data to understand human behaviour:"
    , temperature = 0.8
    , n = 10
    , max_tokens = 150)

 ## For fully reproducible results, we need `temperature = 0`, e.g.:
 gpt_reasoning(prompt_input = "Finish this sentence:/n There is no easier way to learn Julia than"
     , temperature = 0.0
     , max_tokens = 50)

 ## The same example with a different GPT-3 model:
 gpt_reasoning(prompt_input = "Finish this sentence:/n There is no easier way to learn Julia than"
     , model = "gpt-4o-mini"
     , temperature = 0.0
     , max_tokens = 50)

"""
function gpt_reasoning(
    p;
    prompt_input = p,
    model = "o1-mini", # "o1"
    reasoning_effort = "medium",
    output_type = "complete",
    suffix = nothing,
    max_tokens = 100,
    max_completion_tokens = 25000, # recommended in API docs
    temperature = 0.9,
    top_p = 1,
    n = 1,
    logprobs = nothing,
    stop = nothing,
    presence_penalty = 0,
    frequency_penalty = 0,
    verbose = true,
)
    check_api_exists()
    verbose ? println("Using $model") : true

    if (temperature == 0) && (n > 1)
        n = 1
        message(
            "You are running the deterministic model, so `n` was set to 1 to avoid unnecessary token quota usage.",
        )
    end
    parameter_list = Dict(
        "model" => model,
        "suffix" => suffix,
        "max_tokens" => max_tokens,
        "temperature" => temperature,
        "top_p" => top_p,
        "n" => n,
        "logprobs" => logprobs,
        "stop" => stop,
        "presence_penalty" => presence_penalty,
        "frequency_penalty" => frequency_penalty,
    )
    parameter_list = merge(
        parameter_list,
        Dict(
            "max_completion_tokens" => max_completion_tokens,
            "messages" => [
                Dict("role" => "user", "content" => prompt_input),
                #Dict("role" => "developer", "content" => devmessage),
            ],
            "reasoning_effort" => reasoning_effort,
        ),
    )

    thisurl = url.chats
    deletenothingkeys!(parameter_list)
    println(paramter_list)
    headers =
        Dict("Authorization" => "Bearer $api_key", "Content-Type" => "application/json")

    request_base =
        HTTP.request("POST", thisurl, body = JSON.json(parameter_list), headers = headers)
    # request_base.status
    if request_base.status == 200
        request_content = JSON.parse(String(request_base.body))
    end

    if n == 1
        core_output = DataFrame(
            "n" => 1,
            "prompt" => prompt_input,
            "gpt" => request_content["choices"][1]["message"]["content"],
        )
    elseif n > 1
        core_output =
            DataFrame("n" => 1:n, "prompt" => fill(prompt_input, n), "gpt" => fill("", n))
        for i = 1:n
            core_output.gpt[i] = request_content["choices"][i]["text"]
        end
    end


    meta_output = Dict(
        "request_id" => request_content["id"],
        "object" => request_content["object"],
        "model" => request_content["model"],
        "param_prompt" => prompt_input,
        "param_model" => model,
        "param_suffix" => suffix,
        "param_max_tokens" => max_tokens,
        "param_temperature" => temperature,
        "param_top_p" => top_p,
        "param_n" => n,
        "param_logprobs" => logprobs,
        "param_stop" => stop,
        "param_presence_penalty" => presence_penalty,
        "param_frequency_penalty" => frequency_penalty,
        "tok_usage_prompt" => request_content["usage"]["prompt_tokens"],
        "tok_usage_completion" => request_content["usage"]["completion_tokens"],
        "tok_usage_total" => request_content["usage"]["total_tokens"],
    )

    if output_type == "complete"
        output = (core_output, meta_output)
    elseif output_type == "meta"
        output = meta_output
    elseif output_type == "text"
        output = core_output
    end
    return (output)
end
#=
gpt_reasoning(;
    prompt_input = "",
    model = "gpt-4o-mini",
    output_type = "complete",
    suffix = nothing,
    max_tokens = 100,
    temperature = 0.9,
    top_p = 1,
    n = 1,
    logprobs = nothing,
    stop = nothing,
    presence_penalty = 0,
    frequency_penalty = 0,
    verbose = true,
) = gpt_reasoning(
    prompt_input;
    prompt_input = prompt_input,
    model = model,
    output_type = output_type,
    suffix = suffix,
    max_tokens = max_tokens,
    temperature = temperature,
    top_p = top_p,
    n = n,
    logprobs = logprobs,
    stop = stop,
    presence_penalty = presence_penalty,
    frequency_penalty = frequency_penalty,
    verbose = verbose,
);
=#

gpt_reasoning(; kwargs...) = gpt_reasoning(prompt_input; kwargs...);

reasongpt(; kwargs...) = gpt_reasoning(; kwargs...)
reasongpt(p; kwargs...) = gpt_reasoning(p; kwargs...)
