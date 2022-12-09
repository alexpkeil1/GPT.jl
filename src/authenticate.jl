"""
# Set up the authentication with your API key
#
# Access to GPT-3"s functions requires an API key that you obtain from [https://openai.com/api/](https://openai.com/api/). `gpt3_authenticate()` looks for your API key in a file that you provide the path to and ensures you can connect to the models. `gpt3_endsession()` overwrites your API key _for this session_ (it is recommended that you run this when you are done). `check_apikey_form()` is a simple check if any information has been provided at all.
# path: The file path to the API key
#  A confirmation message
#  The easiest way to store you API key is in a `.txt` file with _only_ the API key in it (without quotation marks or other common string indicators). `gpt3_authenticate()` reads the single file you point it to and retrieves the content as authentication key for all requests.
# # Starting a session:

 gpt3_authenticate(path = "./YOURPATH/access_key.txt")

# # After you are finished:
 gpt3_endsession()
"""
function gpt3_authenticate(path)
  global api_key = read(path, String)
  println("Will use --> $api_key for authentication.")
end


function gpt3_endsession()
  global api_key = "---"
  println("-- session ended: you need to re-authenticate again next time.")
end

function check_apikey_form()
  isapi = @isdefined api_key
  if !isapi
    @warn "Use gpt3_authenticate() to set your API key"
  elseif length(api_key) < 10
    @warn "Use gpt3_authenticate() to set your API key"
  else
    message("API looks valid")
  end
end
