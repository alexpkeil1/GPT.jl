"""
 Make a test request to the GPT API

 `gpt_test_completion()` sends a basic [completion request](https://beta.openai.com/docs/api-reference/completions) to the Open AI GPT API.
 verbose: (boolean) if TRUE prints the actual prompt and GPT completion of the test request (default: TRUE).
 
 Returns a message of success or failure of the connection.

 gpt_test_completion()
"""
function gpt_test_completion(verbose=true)
  check_apikey_form()

  test_prompt = "Write a story about R Studio: "
  test_output = gpt_single_completion(prompt_input = test_prompt
                                  , max_tokens = 100)
  ln(".. test successful ..")

  if verbose 
    # print(paste0("Requested completion for this prompt --> ", test_prompt))
    # print(paste0("GPT completed --> ", test_output))
    test_output
  end
end
