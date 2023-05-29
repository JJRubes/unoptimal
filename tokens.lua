tokens = {}

tokens.ip = 0
tokens.word = ""
tokens.code = {}
tokens.tokens = {}
tokens.token = {}

tokens.cont = function()
  tokens.ip = tokens.ip + 1

  if tokens.ip > #tokens.code then
    return false
  end

  tokens.word = tokens.code[tokens.ip]

  return true
end

tokens.add_token = function()
  table.insert(tokens.tokens, tokens.token)
  tokens.token = {}
end

tokens.return_token = function()
  local t = tokens.token
  tokens.token = {arguments={}}
  return t
end

tokens.name = function(name)
  tokens.token.name = name
  tokens.cont()
end

tokens.add_l = function()
  if(tokens.word == "X" or tokens.word == "Y" or
    tokens.word == "Z" or tokens.word == "D") then
    table.insert(tokens.token.arguments, tokens.word)
  else
    error("Invalid Loop Name")
  end

  tokens.cont()
end

tokens.add_n = function()
  table.insert(tokens.token.arguments, tonumber(tokens.word))
  tokens.cont()
end

tokens.add_e = function()
  if(tokens.word == "X" or tokens.word == "Y" or
    tokens.word == "Z" or tokens.word == "D") then
    tokens.add_l()
  else
    tokens.add_n()
  end
end

tokens.commands = {
  "add",
  "sub",
  "mul",
  "div",
  "and",
  "or",
  "xor",
  "not",
  "mov",
  "set",
  "in",
  "out",
  "nop",
  "repeat",
  "if"
}

tokens.create_token = function()
  if tokens.word == "def" then
    local name = tokens.word
    tokens.cont()
    local func_name = tokens.word
    tokens.cont()
    local calls = {}
    local commands = 0
    while tokens.word ~= "end" do
      for i, val in ipairs(tokens.commands) do
        if tokens.word == val then
          commands = commands + 1
        end
      end
      table.insert(calls, tokens.create_token())
    end
    tokens.cont()
    tokens.token.name = name
    tokens.token.func_name = func_name
    tokens.token.calls = calls
    tokens.token.commands = commands
    if tokens.token.commands ~= 15 and
      tokens.token.calls ~= 40 and
      tokens.token.calls ~= 60 then
      print(commands)
      error("Function definition contains illegal number of instructions")
    end
    return tokens.return_token()
    
  elseif tokens.word == "repeat" then
    tokens.name(tokens.word)
    tokens.add_e()
    tokens.token.calls = {}
    while tokens.word ~= "end" do
      for i, val in ipairs(tokens.commands) do
        if tokens.word == val then
          error("Repeat can only contain function calls")
          break
        end
      end

      table.insert(tokens.token.calls, tokens.create_token())
      tokens.cont()
    end
    tokens.cont()

  elseif tokens.word == "add" then
    tokens.name(tokens.word)
    tokens.add_l()
    tokens.add_e()
    tokens.add_e()
    return tokens.return_token()
  elseif tokens.word == "sub" then
    tokens.name(tokens.word)
    tokens.add_l()
    tokens.add_e()
    tokens.add_e()
    return tokens.return_token()
  elseif tokens.word == "mul" then
    tokens.name(tokens.word)
    tokens.add_l()
    tokens.add_e()
    tokens.add_e()
    return tokens.return_token()
  elseif tokens.word == "div" then
    tokens.name(tokens.word)
    tokens.add_l()
    tokens.add_e()
    tokens.add_e()
    return tokens.return_token()
  elseif tokens.word == "and" then
    tokens.name(tokens.word)
    tokens.add_l()
    tokens.add_e()
    tokens.add_e()
    return tokens.return_token()
  elseif tokens.word == "or" then
    tokens.name(tokens.word)
    tokens.add_l()
    tokens.add_e()
    tokens.add_e()
    return tokens.return_token()
  elseif tokens.word == "xor" then
    tokens.name(tokens.word)
    tokens.add_l()
    tokens.add_e()
    tokens.add_e()
    return tokens.return_token()
  elseif tokens.word == "not" then
    tokens.name(tokens.word)
    tokens.add_l()
    tokens.add_e()
    return tokens.return_token()
  elseif tokens.word == "mov" then
    tokens.name(tokens.word)
    tokens.add_l()
    tokens.add_e()
    return tokens.return_token()
  elseif tokens.word == "set" then
    tokens.name(tokens.word)
    tokens.add_e()
    return tokens.return_token()
  elseif tokens.word == "in" then
    tokens.name(tokens.word)
    tokens.add_l()
    return tokens.return_token()
  elseif tokens.word == "out" then
    tokens.name(tokens.word)
    tokens.add_e()
    return tokens.return_token()
  elseif tokens.word == "nop" then
    tokens.name(tokens.word)
    return tokens.return_token()
  else
    tokens.token.name = "func_call"
    tokens.token.func_name = tokens.word
    tokens.cont()
    return tokens.return_token()
  end
end

tokens.tokenise = function(code)
  tokens.ip = 0
  tokens.word = ""
  tokens.code = {}
  tokens.tokens = {}
  tokens.token = {arguments={}}

  for word in code:gmatch("%S+") do
    table.insert(tokens.code, word)
  end

  tokens.ip = 0
  tokens.cont()

  while tokens.ip <= #tokens.code do
    table.insert(tokens.tokens, tokens.create_token())
  end
  return tokens.tokens
end

return tokens
