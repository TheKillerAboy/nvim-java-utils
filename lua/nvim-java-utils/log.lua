local M = {}

function M.log(message)
  local log_file_path = './log/nvim-java-utils.log'
  local log_file_handle = io.open(log_file_path, "a")

  io.output(log_file_handle)
  io.write(message)
  io.close(log_file_handle)
end

return M
