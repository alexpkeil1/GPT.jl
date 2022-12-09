"""
Obtains text embeddings for a single character (string) from the GPT-3 API

Description
`gpt3_single_embedding()` sends a single [embedding request](https://beta.openai.com/docs/guides/embeddings) to the Open AI GPT-3 API.

 The function supports the text similarity embeddings for the four GPT-3 models as specified in the parameter list. The main difference between the four models is the sophistication of the embedding representation as indicated by the vector embedding size.
  - Ada (1024 dimensions)
  - Babbage (2048 dimensions)
  - Curie (4096 dimensions)
  - Davinci (12288 dimensions)

Note that the dimension size (= vector length), speed and [associated costs](https://openai.com/api/pricing/) differ considerably.

These vectors can be used for downstream tasks such as (vector) similarity calculations.
   input character that contains the text for which you want to obtain text embeddings from the GPT-3 model
   model a character vector that indicates the [similarity embedding model](https://beta.openai.com/docs/guides/embeddings/similarity-embeddings); one of "text-similarity-ada-001" (default), "text-similarity-curie-001", "text-similarity-babbage-001", "text-similarity-davinci-001"

 Returns A numeric vector (= the embedding vector)
# First authenticate with your API key via `gpt3_authenticate("pathtokey")`

# Once authenticated:

## Simple request with defaults:
 sample_string = "London is one of the most liveable cities in the world. The city is always full of energy and people. It"s always a great place to explore and have fun."
 gpt3_single_embedding(input = sample_string)

## Change the model:
 gpt3_single_embedding(input = sample_string
     , model = "text-similarity-curie-001")
"""
function gpt3_single_embedding(
  input,
  model = "text-similarity-ada-001"
)
  check_api_exists()
   parameter_list = Dict(
     "model" => model, 
     "input" => input
    )  
  headers = Dict(
    "Authorization" => "Bearer $api_key",
    "Content-Type" => "application/json"
    )

   request_base = HTTP.request(
     "POST", 
     url.embeddings,  # constant "https://api.openai.com/v1/embeddings"
     body=JSON.json(parameter_list),
     headers=headers
   )
   ###
  #request_base = httr::POST(url = url.embeddings
  #                          , body = parameter_list
  #                          , httr::add_headers(Authorization = paste("Bearer", api_key))
  #                          , encode = "json")

# left off here
    request_content = JSON.parse(String(request_base.body))

  output_base = httr::content(request_base)

  embedding_raw = Float64.(request_content["data"][1]["embedding"])
  return(embedding_raw)
end
