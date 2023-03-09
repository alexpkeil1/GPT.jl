"""
 Make a test request to the GPT-3 API

 `gpt3_test_completion()` sends a basic [completion request](https://beta.openai.com/docs/api-reference/completions) to the Open AI GPT-3 API.
 verbose: (boolean) if TRUE prints the actual prompt and GPT-3 completion of the test request (default: TRUE).
 
 Returns a message of success or failure of the connection.

 gpt3_test_completion()
"""
function gpt3_test_completion(verbose=true)
  check_apikey_form()

  test_prompt = "Write a story about R Studio: "
  test_output = gpt3_single_completion(prompt_input = test_prompt
                                  , max_tokens = 100)
  ln(".. test successful ..")

  if verbose 
    # print(paste0("Requested completion for this prompt --> ", test_prompt))
    # print(paste0("GPT-3 completed --> ", test_output))
    test_output
  end
end
