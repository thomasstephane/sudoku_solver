class Sudoku
  attr_accessor :input

  def initialize(input)
    @input = input.split(//)
  end

  def initialize_board
    @cells = []
    @size = Math.sqrt(input.length).to_i
    @box_size = Math.sqrt(@size).to_i
    @easting = (1..@size).to_a.map(&:to_s)
    @northing = (1..@size).to_a.map(&:to_s)
    @row_numbers = (1..@size).to_a.join.scan(/.{#{@box_size}}/)
    @column_numbers = (1..@size).to_a.join.scan(/.{#{@box_size}}/)
    possibilities_array
    @size.times do |i|
      @size.times do |j|
        @cells << { :easting => @easting[i], :northing => @northing[j], :value => "0", :possibilities => possibilities_array }
      end
    end
    @cells.each do |hash|
      hash[:value] = @input[@cells.index(hash)] 
      hash[:possibilities] = @input[@cells.index(hash)] if @input[@cells.index(hash)]!="0"
    end
  end

  def check_rc
    @cells.each do |hash_i|
      if hash_i[:value] == "0"
        @cells.each do |hash_j|
          if hash_j[:easting] == hash_i[:easting]
            hash_i[:possibilities].delete(hash_j[:value])
          elsif hash_j[:northing] == hash_i[:northing]
            hash_i[:possibilities].delete(hash_j[:value])
          end
        end
      end
    end
  end

  def check_boxes
    @cells.each do |hash_i|
      if hash_i[:value] == "0"
        box_row_index = @row_numbers.index { |i| i.include?(hash_i[:easting]) == true }
        box_column_index = @column_numbers.index { |i| i.include?(hash_i[:northing]) == true }
        @cells.each do |hash_j|
          if @row_numbers[box_row_index].include?(hash_j[:easting]) && @column_numbers[box_column_index].include?(hash_j[:northing])
            hash_i[:possibilities].delete(hash_j[:value])
          end
        end
      end
    end
  end

  def flatten
    @cells.each do |h|
      if h[:possibilities].is_a?(Array) && h[:possibilities].length == 1
        h[:possibilities] = h[:possibilities][0] 
        h[:value] = h[:possibilities]
      end
    end
  end

  def solved?
    @cells.each do |h|
      if h[:value] == "0"
        @solved = false
        break  
      else
        @solved = true
      end
    end
    @solved
  end

  def print_board
    i = 1
    @cells.each do |h|
      if h[:easting].to_i % @box_size == 1 && h[:northing] == "1"
        puts "\n----------------------"
      elsif i % @size == 1
        print "\n"
      elsif i % @box_size == 1
        print "| "
      else
      end
      print "#{h[:value]} "
      i += 1
    end
    puts "\n----------------------\n\n"
   end

  def solve
    counter = 0
    init_time = Time.now
    initialize_board
    until solved?
      check_rc
      check_boxes unless solved?
      flatten
      counter += 1
    end
    final_time = Time.now
    print "\n---------- @cells after solved in #{counter} iterations and #{final_time - init_time} seconds---------\n"
    print_board
  end

  def possibilities_array
    @letter = "a"
    if @size < 10
      @possibilities = (1..@size).to_a.map(&:to_s) 
    else
      @possibilities = (1..9).to_a.map(&:to_s)
      until @possibilities.size == @size
        @possibilities << @letter
        @letter = @letter.next
      end
    end
    @possibilities
  end
end