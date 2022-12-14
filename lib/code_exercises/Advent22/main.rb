def data(file)
  File.readlines("input/#{file}.txt", chomp: true)
end

class Elf
  attr_reader :name, :cal

  def initialize(name)
    @name = name
    @cal = 0
  end

  def add_cal(new_cal)
    @cal += new_cal
  end
end

def day1_a
  elf = Elf.new(1)
  max_cal = elf
  data('day1').each do |line|
    if line.empty?
      max_cal = elf if elf.cal > max_cal.cal
      elf = Elf.new(elf.name + 1) 
      next
    end
    elf.add_cal(line.to_i)
  end
  puts max_cal.cal
end

def day1_b
  elf = Elf.new(1)
  max_cal = [elf]
  data('day1').each do |line|
    if line.empty?
      if max_cal.size < 3
        max_cal.push(elf)
      elsif elf.cal > max_cal[2].cal
        max_cal.push(elf).sort!{|a,b| b.cal <=> a.cal }.pop
      end
      elf = Elf.new(elf.name + 1) 
      next
    end
    elf.add_cal(line.to_i)
  end
  puts max_cal.sum(&:cal)
end

def day2_a
  dict = day2_dict.merge({ 'X' => 1, 'Y' => 2, 'Z' => 3 })
  score = 0
  data('day2').each do |line|
    choices = line.split(' ')
    result = (dict[choices[0]] - dict[choices[1]]) % 3
    score += dict[choices[1]] + (result == 0 ? 3  : result == 2 ? 6  : 0)
  end
  puts score
end

def day2_b
  dict = day2_dict.merge({ 'X' => 0, 'Y' => 3, 'Z' => 6 })
  score = 0
  data('day2').each do |line|
    choice, result = line.split(' ')
    player_choice = case result
    when 'X'
      (dict[choice] - 1) % 3
    when 'Y'
      dict[choice]
    when 'Z'
      (dict[choice] + 1) % 3
    end
    score += dict[result] + (player_choice == 0 ? 3 : player_choice)
  end
  puts score
end

def day2_dict
  {
    'A' => 1,
    'B' => 2,
    'C' => 3
  }
end

def day3_a
  priority = 0
  data('day3').each do |line|
    items = {}
    shared_char = for i in 0..line.length do
      if i < line.length / 2
        items[line[i]] = true
      else
        break line[i] if items[line[i]]
      end
    end
    priority += char_priority(shared_char.ord)
  end
  puts priority
end

def day3_b
  priority = 0
  lines = data('day3')
  idx = 0
  while idx < lines.length do
    puts "call at idx: #{idx}"
    priority += char_priority(shared_group_char_ord(lines[idx..idx+2]))
    idx += 3
  end
  puts priority
end

def shared_group_char_ord(lines)
  items = {}
  puts lines
  0.upto(2) do |idx|
    0.upto(lines[idx].length) do |i|
      char = lines[idx][i]
      items[char] = idx if items[char] == (idx == 0 ? nil : idx - 1)
      return char.ord if items[char] == 2
    end
  end
end

def char_priority(c)
  c < 97 ? c - 38 : c - 96
end

def day4_a
  res = 0
  data('day4').each do |line|
    e1, e2 = line.split(',').map { |s| s.split('-').map { |n| n.to_i } }
    res += compare_sections_a(e1, e2) || compare_sections_a(e2, e1) ? 1 : 0
  end
  puts res
end

def compare_sections_a(s1, s2)
  s1[0] <= s2[0] && s1[1] >= s2[1]
end

def day4_b
  res = 0
  data('day4').each do |line|
    e1, e2 = line.split(',').map { |s| s.split('-').map { |n| n.to_i } }
    res += compare_sections_b(e1, e2) || compare_sections_b(e2, e1) ? 1 : 0
  end
  puts res
end

def compare_sections_b(s1, s2)
  (s1[0] <= s2[0] && s1[1] >= s2[0]) ||  (s1[0] >= s2[0] && s1[1] <= s2[1])
end

def day5_a
  lines = data('day5')
  stacks = Array.new((lines[0].length+1)/4) {[]}
  lines.each do |line|
    if line[0] == 'm'
      instruction = line.split(' ').map {|s| s.to_i > 0 ? s.to_i : nil }.compact
      moving, from_stack, to_stack = instruction
      1.upto(moving) do
        stacks[to_stack-1].push(stacks[from_stack-1].pop)
      end
    elsif line.empty?
      stacks.map!(&:reverse)
    elsif line[1] != '1'
      0.upto(stacks.length - 1) do |i|
        crate = line[(4*i)+1]
        stacks[i].push(crate) unless crate == " "
      end
    end
  end
  result = ""
  stacks.each { |stack| result += stack.pop || '' }
  puts result
end

def day5_b
  lines = data('day5')
  stacks = Array.new((lines[0].length+1)/4) {[]}
  lines.each do |line|
    if line[0] == 'm'
      instruction = line.split(' ').map {|s| s.to_i > 0 ? s.to_i : nil }.compact
      moving, from_stack, to_stack = instruction
      stacks[to_stack-1].concat(stacks[from_stack-1].slice!(-moving..))
    elsif line.empty?
      stacks.map!(&:reverse)
    elsif line[1] != '1'
      0.upto(stacks.length - 1) do |i|
        crate = line[(4*i)+1]
        stacks[i].push(crate) unless crate == " "
      end
    end
  end
  result = ""
  stacks.each { |stack| result += stack.pop || '' }
  puts result
end

def day6_a
  line = data('day6')[0]
  0.upto(line.length - 1) do |i|
    return i+4 if line[i..i+3].split('').uniq.length == 4
  end
end

def day6_b
  line = data('day6')[0]
  char_counts = Hash.new(0)
  0.upto(line.length - 1) do |i|
    char_counts[line[i]] += 1
    if i >= 14
      char_counts[line[i-14]] -= 1 if i >= 14
      return i+1 unless char_counts.any? {|k,v| v > 1}
    end
  end
end

class Day7
  def initialize
    @lines = data('day7')
    @location = []
    @file_structure = { '/' => { files: 0 } }
    parse_input
    calc_size(file_structure)
  end

  def part_a
    file_structure.to_s.split("files=>")[1..].map(&:to_i).sum{|n| n <= 100000 ? n : 0 }
  end

  def part_b
    find_smallest_valid_dir(file_structure["/"][:files] - 40000000)
  end

  private
  attr_accessor :lines, :file_structure, :location

  def parse_input
    lines.each do |line|
      line = line.split(' ')
      case line[0]
      when '$'
        if line[1] == 'cd'
          line[2] == '..' ? location.pop : location.push(line[2])
        end
      when 'dir'
        file_structure.dig(*location)[line[1]] = { files: 0 }
      else
        file_structure.dig(*location)[:files] += line[0].to_i
      end
    end
  end

  def calc_size(dir)
    dir.each do |name, value|
      unless name == :files
        file_size = calc_size(value) || 0
        dir[:files] += file_size unless !dir[:files] || dir.keys.size == 1 || dir.keys.first == '/'
      end
    end
    dir[:files]
  end

  def find_smallest_valid_dir(space_needed)
    opts = [file_structure["/"]]
    min = file_structure["/"][:files]
    while opts.length > 0
      opt = opts.pop
      min = opt[:files] if opt[:files] < min
      opt.each_key do |k|
        next if k == :files
        opts.push(opt[k]) if opt[k][:files] >= space_needed
      end
    end
    min
  end
end

class Day8
  def initialize
    @lines = data('day8')
    @num_rows = @lines.length
    @num_cols = @lines[0].length
    @num_visible = (@num_rows + @num_cols - 2) * 2
    @visible = []
    1.upto(num_rows) {|row| @visible.push( Array.new(num_cols,(row == 1 || row == num_rows) ? true : nil))}
  end

  def part_a
    def left_right
      1.upto(num_rows - 2) do |row_idx|
        left_tallest = @lines[row_idx][0]
        right_tallest = @lines[row_idx][-1]
        @visible[row_idx][0] = true
        @visible[row_idx][-1] = true
        1.upto(num_cols - 1) do |col_offset|
          left_val = @lines[row_idx][col_offset]
          if left_val > left_tallest
            # puts "Left - [#{row_idx},#{col_offset}] Val: #{left_val} Tallest: #{left_tallest}"
            left_tallest = left_val
            unless @visible[row_idx][col_offset]
              @visible[row_idx][col_offset] = true
              @num_visible += 1
            end  
          end
  
          right_val = @lines[row_idx][-col_offset]
          if right_val > right_tallest
            # puts "Right - [#{row_idx},-#{col_offset}] Val: #{right_val} Tallest: #{right_tallest}"
            right_tallest = right_val
            unless @visible[row_idx][-col_offset]
              @visible[row_idx][-col_offset] = true
              @num_visible += 1
            end
          end
        end
        # puts "End of row #{row_idx} l<>r loop. Visible: #{@visible[row_idx].to_s}"
      end
    end
  
    def up_down
      1.upto(num_cols - 2) do |col_idx|
        up_tallest = @lines[0][col_idx]
        down_tallest = @lines[-1][col_idx]
        1.upto(num_rows - 1) do |row_offset|
          up_val = @lines[row_offset][col_idx]
          if up_val > up_tallest
            up_tallest = up_val
            unless @visible[row_offset][col_idx]
              @visible[row_offset][col_idx] = true
              @num_visible += 1
            end
          end
          down_val = @lines[-row_offset][col_idx]
          if down_val > down_tallest
            down_tallest = down_val
            unless @visible[-row_offset][col_idx]
              @visible[-row_offset][col_idx] = true
              @num_visible += 1
            end
          end
        end
        # col = ""
        # @visible.each {|row| col += " #{row[col_idx] || 'nil '}"}
        # puts "End of col #{col_idx} u<>d loop. Visible: #{col}"
      end
    end

    left_right
    up_down
    @num_visible
  end

  def part_b
    max_view = 0
    1.upto(num_rows-2) do |row_idx|
      1.upto(num_cols-2) do |col_idx|
        tree_val = @lines[row_idx][col_idx]
        left, right, up, down = true, true, true, true
        scenic_score = 1
        distance = 0
        while left || right || up || down
          distance += 1
          if left
            if (col_idx - distance <= 0) || (@lines[row_idx][col_idx-distance] >= tree_val)
              left = false
              scenic_score *= distance
            end
          end
          if right
            if (col_idx + distance >= num_cols - 1) || (@lines[row_idx][col_idx+distance] >= tree_val)
              right = false
              scenic_score *= distance
            end
          end
          if up
            if (row_idx - distance <= 0) || (@lines[row_idx-distance][col_idx] >= tree_val)
              up = false
              scenic_score *= distance
            end
          end
          if down
            if (row_idx + distance >= num_rows - 1) || (@lines[row_idx+distance][col_idx] >= tree_val)
              down = false
              scenic_score *= distance
            end
          end
        end
        max_view = scenic_score if scenic_score > max_view
      end
    end
    max_view
  end

  private
  attr_accessor :num_rows, :num_cols
end

module Day9
  class Node
    attr_accessor :location, :parent, :child

    def initialize(parent=nil, child=nil, x=0, y=0)
      @parent = parent
      @child = child
      @location = { x: x, y: y }
    end
  end

  class Rope
    attr_accessor :rope, :tail_visited

    def initialize(nodes, x=0, y=0)
      @rope = []
      1.upto(nodes) { |i|
        node = Node.new()
        unless @rope.empty?
          @rope[-1].child = node
          node.parent = @rope[-1]
        end
        @rope.push(node)
      }
      @tail_visited = { [x, y] => true }
    end


    def move(node, x, y)
      node.location[:x] += x
      node.location[:y] += y
      move_child = false

      if node.child
        puts "Head: #{node.location.to_s}"
        x_diff = node.location[:x] - node.child.location[:x]
        y_diff = node.location[:y] - node.child.location[:y]

        if x_diff.abs + y_diff.abs > 2
          puts "hello?"
          move_child = true
          x = x < 0 ? -1 : 1
          y = y < 0 ? -1 : 1
        elsif x_diff.abs > 1
          move_child = true
          x = x < 0 ? -1 : 1
        elsif y_diff.abs > 1
          move_child = true
          y = y < 0 ? -1 : 1
        end

        move(node.child, x, y) if move_child

      else
        puts node.location.to_s unless @tail_visited[node.location]
        @tail_visited[node.location] = true unless node.child
      end
    end
  end

  class Compiler
    def self.run(nodes)
      new(nodes).run
    end
    
    def initialize(nodes)
      @rope = Rope.new(nodes)
      @head = @rope.rope[0]
    end

    def run
      data('day9').each { |line| run_line(line) }
      @rope.tail_visited.keys.count
    end

    def run_line(line)
      x, y, steps = parse_instruction(line)
      1.upto(steps) do
        @rope.move(@head, x, y)
      end
    end

    def parse_instruction(line)
      instr = line.split(" ")
      x = instr[0] == 'R' ? 1 : instr[0] == 'L' ? -1 : 0
      y = instr[0] == 'D' ? 1 : instr[0] == 'U' ? -1 : 0
      [x,y,instr[1].to_i]
    end
  end
end

# def day9_a
#   visited = { [0,0] => true }
#   head_loc = { x: 0, y: 0 }
#   tail_loc = { x: 0, y: 0 }
#   data('day9').each do |line|
#     instruction = line.split(" ")
#     x, y = 0, 0
#     case instruction[0]
#     when 'R'
#       x = 1
#     when 'L'
#       x = -1
#     when 'U'
#       y = -1
#     when 'D'
#       y = 1
#     end

#     1.upto(instruction[1].to_i) do |i|
#       head_loc[:x] += x
#       head_loc[:y] += y
#       # puts "Head: #{[head_loc[:x], head_loc[:y]].to_s}"

#       x_diff = head_loc[:x] - tail_loc[:x]
#       y_diff = head_loc[:y] - tail_loc[:y]

#       # puts "x_diff: #{x_diff} y_diff: #{y_diff}"

#       if x_diff.abs + y_diff.abs > 2
#         # puts "?"
#         tail_loc[:x] += x_diff / x_diff.abs
#         tail_loc[:y] += y_diff / y_diff.abs
#       elsif x_diff.abs > 1
#         # puts x_diff
#         tail_loc[:x] += 1 % x_diff
#       elsif y_diff.abs > 1
#         # puts y_diff

#         tail_loc[:y] += 1 % y_diff
#       end

#       # puts "Tail: #{[tail_loc[:x], tail_loc[:y]].to_s}"
#       visited[[tail_loc[:x], tail_loc[:y]]] = true
#       # puts "-----------------------------"
#     end
#   end
#   # puts visited.to_s
#   visited.keys.count
# end

puts Day9::Compiler.run(2)