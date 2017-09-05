defmodule Comms do

  def sendrecv(pid, data) do
    send(pid, data)      # send move to referee
    result = receive do  # receive new grid and return val from referee
      {grid, ret} ->
        {grid, ret}
    end
    result
  end

end
