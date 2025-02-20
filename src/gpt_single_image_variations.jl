"""
 Makes a single completion request to the GPT-3 API

 @description
 `gpt_single_image_edit()` sends a single [image edit request](https://beta.openai.com/docs/api-reference/images/create-edit) to the Open AI GPT-3 API.
 @details For a general guide on the completion requests, see [https://beta.openai.com/docs/guides/images/introduction](https://beta.openai.com/docs/guides/images/introduction). This function provides you with an R wrapper to send requests with the full range of request parameters as detailed on [https://beta.openai.com/docs/api-reference/images/create-edit](https://beta.openai.com/docs/api-reference/images/create-edit) and reproduced below.
(from the official API documentation: The image edits endpoint allows you to edit and extend an image by uploading a mask. The transparent areas of the mask indicate where the image should be edited, and the prompt should describe the full new image, not just the erased area.)

*Parameters*

   - `n` numeric: (default: 1) specifying the number of completions per request (from the official API documentation: How many completions to generate for each prompt. **Note: Because this parameter generates many completions, it can quickly consume your token quota.** Use carefully and ensure that you have reasonable settings for max_tokens and stop._)
   - `size`: string (default: "256x256") one of "256x256", "512x512", "1024x1024" (from the official API documentation: The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024)
   - `image`: string (default: nothing) image path (MUST BE PNG) (from the official API documentation: The image to edit. Must be a valid PNG file, less than 4MB, and square. If mask is not provided, image must have transparency, which will be used as the mask.)
   - `response_format`: string  (default: "url")   one of "url", "b64_json" (from the official API documentation: The format in which the generated images are returned. Must be one of url or b64_json.)
   - `output_type`: character determining the output provided: "complete" (default), "image" or "meta"

 A tuple with two DataFrames (if `output_type` is the default "complete"): 
 
   - [1] contains the data table with the columns `n` (= the mo. of `n` responses requested), `prompt` (= the prompt that was sent), and `gpt` (= the completion as returned from the GPT-3 model). 
   - [2] contains the meta information of the request, including the request id, the parameters of the request and the token usage of the prompt (`tok_usage_prompt`), the completion (`tok_usage_completion`) and the total usage (`tok_usage_total`).

 If `output_type` is "text", only the DataFrames in slot [1] is returned.

 If `output_type` is "meta", only the DataFrames in slot [2] is returned.


 _Examples_
 # First authenticate with your API key via `gpt_authenticate("pathtokey")`
img1 = gpt_single_image(
    "a meme about the dangers of AI",
       size="512x512",
    n=1
)

f1 = expanduser("~/temp/testimg_var1.png")
f2 = expanduser("~/temp/testimg_var2.png")
download(img1[1].gpt[1], f1)

img2 = gpt_single_image_variations(
        image = f1,
        size="512x512"
    )
download(img2[1].gpt[1], f2)

"""
function gpt_single_image_variations(
  img=nothing;
  model = "dall-e-2",
  n = 1,
  size = "256x256", # "512x512", "1024x1024"
  response_format = "url", # "b64_json"
  image = img,
  output_type = "complete",
  verbose = verbose
)
  check_api_exists()
  if(model != "dall-e-2")
    throw("model must be dall-e-2")
  end
  gptverbose ? println("Using $model") : true

  parameter_list = Dict(
    #"n" => n,
    "model" => model,
    "size" => size,
    "image" => open(image, "r"),
    "response_format" => response_format
  )

  deletenothingkeys!(parameter_list)    

  body = HTTP.Form(collect(parameter_list))

  headers = Dict(
    "Authorization" => "Bearer $api_key",
    #"Content-Type" => "application/json"
    )

  request_base = HTTP.request(
        "POST",
        url.variations,
        headers=headers,
        body=body
      );
  
  # request_base.status
  if request_base.status == 200
    request_content = JSON.parse(String(request_base.body))
  end
  #
  if n == 1
    core_output = DataFrame(
                   "n" => 1,
                   "gpt" => request_content["data"][1]["url"]
                   )
  elseif n > 1
    core_output = DataFrame(
                   "n" => 1:n,
                   "gpt" => fill("", n)
                   )
    for i in 1:n
      core_output.gpt[i] = request_content["data"][i]["url"]
    end
  end

  meta_output = Dict(
    "request_created" => request_content["created"],
    "param_size" => size,
    "param_response_format" => response_format
  )

  if output_type == "complete"
    output = (core_output, meta_output)
  elseif output_type == "meta"
    output = meta_output
  elseif output_type == "image"
    output = core_output
  end
  return(output)
end

#= 
gpt_single_image_variations(;
image = nothing,
n = 1,
size = "256x256", # "512x512", "1024x1024"
response_format = "url", # "b64_json"
output_type = "complete"
) = gpt_single_image_variations(
        image;
        image=image,
        n = n,
        size = size, 
        response_format = response_format,
        output_type = output_type
        )
;
 =#