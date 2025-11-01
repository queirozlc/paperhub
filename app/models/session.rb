class Session
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def to_s
    "sessions:#{id}"
  end
end
