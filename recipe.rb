class Recipe
  attr_reader :name, :description, :prep_time, :difficulty, :status

  def initialize(name, description, prep_time, difficulty, status = false)
    @name = name
    # @ingredients = ingredients
    @description = description
    # @instructions = instructions
    @prep_time = prep_time
    @difficulty = difficulty
    @status = status
  end

  def status?
    @status
  end

  def mark_as_done
    @status = true
  end
end
