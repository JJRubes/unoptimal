interpreter = {}

tokens = require("tokens")

loop = {}

function loop:size(length)
  -- hack because initialising the array in the constructor
  -- just didn't work
  if not self.array then
    self.array = {0}
  end

  while #self.array > length do
    if self.ip == #self.array then
      table.remove(self.array, 0)
      self.ip = #self.array
    else
      table.remove(self.array, self.ip + 1)
    end
  end

  while #self.array < length do
    table.insert(self.array, self.ip, 0)
    self.ip = self.ip + 1
  end
end

function loop:new(o)
  o = o or {}
  setmetatable(o, self)
  self.ip = 1
  self.__index = self
  return o
end

function loop:inc()
  self.ip = (self.ip % #self.array) + 1
end

function loop:get()
  return self.array[self.ip]
end

function loop:set(value)
  self.array[self.ip] = value
end

interpreter.token_list = {}

interpreter.get_argument = function(token, n)
  local value = token.arguments[n]
  if value == nil then
    error("argument pointer out of range")
  end

  -- if there is a loop by the name of the argument
  -- get the value of the loop, otherwise use the literal value
  if interpreter.loops[value] then
    value = interpreter.loops[value]:get()
    if value == nil then
      error("get failed to get anything")
    end
  end
  return value
end

interpreter.compare = function(x, y, str)
  if str == "==" then
    return x == y
  elseif str == "!=" then
    return x ~= y
  elseif str == "<" then
    return x < y
  elseif str == "<=" then
    return x <= y
  elseif str == ">" then
    return x > y
  elseif str == ">=" then
    return x >= y
  else
    error("compare not work")
  end
end

function interpreter.run_command(token)
  -- if token.name ~= "nop" then
  --   print(token.name)
  -- end
  if token.name == "repeat" then
    local x = interpreter.get_argument(token, 1)
    interpreter.inc_all()
    for i=1, x do
      for i, func in ipairs(token.calls) do
        interpreter.run_command(func)
      end
    end

  elseif token.name == "if" then
    local x = interpreter.get_argument(token, 1)
    local y = interpreter.get_argument(token, 2)
    -- print(x, token.comp, y)
    interpreter.inc_all()
    if interpreter.compare(x, y, token.comp) then
      -- print("true")
      for i, func in ipairs(token.on_true) do
        interpreter.run_command(func)
      end
    else
      -- print("false")
      for i, func in ipairs(token.on_false) do
        interpreter.run_command(func)
      end
    end

  elseif token.name == "add" then
    local x = interpreter.get_argument(token, 2)
    local y = interpreter.get_argument(token, 3)
    interpreter.loops[token.arguments[1]]:set(x + y)
    interpreter.inc_all()

  elseif token.name == "sub" then
    local x = interpreter.get_argument(token, 2)
    local y = interpreter.get_argument(token, 3)
    interpreter.loops[token.arguments[1]]:set(x - y)
    interpreter.inc_all()

  elseif token.name == "mul" then
    local x = interpreter.get_argument(token, 2)
    local y = interpreter.get_argument(token, 3)
    interpreter.loops[token.arguments[1]]:set(x * y)
    interpreter.inc_all()

  elseif token.name == "div" then
    local x = interpreter.get_argument(token, 2)
    local y = interpreter.get_argument(token, 3)
    interpreter.loops[token.arguments[1]]:set(x / y)
    interpreter.inc_all()

  elseif token.name == "and" then
    local x = interpreter.get_argument(token, 2)
    local y = interpreter.get_argument(token, 3)
    interpreter.loops[token.arguments[1]]:set(x & y)
    interpreter.inc_all()

  elseif token.name == "or" then
    local x = interpreter.get_argument(token, 2)
    local y = interpreter.get_argument(token, 3)
    interpreter.loops[token.arguments[1]]:set(x | y)
    interpreter.inc_all()

  elseif token.name == "xor" then
    local x = interpreter.get_argument(token, 2)
    local y = interpreter.get_argument(token, 3)
    interpreter.loops[token.arguments[1]]:set(x ~ y)
    interpreter.inc_all()

  elseif token.name == "cpy" then
    local x = interpreter.get_argument(token, 2)
    interpreter.loops[token.arguments[1]]:set(x)
    interpreter.inc_all()

  elseif token.name == "set" then
    local x = interpreter.get_argument(token, 1)
    if x < 0 then
      error("Negative values for set not accepted")
    end
    interpreter.loops["D"]:size(2^x)
    interpreter.inc_all()

  elseif token.name == "in" then
    local x = io.read(1)
    if x then
      x = string.byte(x)
    else
      x = -1
    end
    interpreter.loops[token.arguments[1]]:set(x)
    interpreter.inc_all()

  elseif token.name == "out" then
    local x = interpreter.get_argument(token, 1)
    if x == -1 then
      error("attempted to output -1 as a character")
    end
    io.write(string.char(x))
    interpreter.inc_all()

  elseif token.name == "nop" then
    interpreter.inc_all()

  elseif token.name == "func_call" then
    for i, command in ipairs(interpreter.funcs[token.func_name].calls) do
      interpreter.run_command(command)
    end

  end
end

interpreter.inc_all = function()
  interpreter.loops.X:inc()
  interpreter.loops.Y:inc()
  interpreter.loops.Z:inc()
  interpreter.loops.D:inc()
end

interpreter.def = function(token)
  interpreter.funcs = token.calls
end

function interpreter.interpret(code)
  ---- Tokenise the code ----
  interpreter.token_list = tokens.tokenise(code)
  ---- Get the first token ----
  interpreter.tp = 1
  token = interpreter.token_list[interpreter.tp]

  ---- Initialise loops ----
  interpreter.loops = {X=loop:new(), Y=loop:new(), Z=loop:new(), D=loop:new()}
  interpreter.loops.X:size(7)
  interpreter.loops.Y:size(37)
  interpreter.loops.Z:size(97)
  interpreter.loops.D:size(1)

  ---- Define functions ----
  interpreter.funcs = {}
  for i, command in ipairs(interpreter.token_list) do
    if command.name == "def" then
      interpreter.funcs[command.func_name] = command
    else
      error("Commands outside of a function definition")
    end
  end

  if not interpreter.funcs.entry then
    error("No entry function")
  end
  interpreter.run_command({name="func_call", func_name="entry"})
end

return interpreter
