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
    @file_structure = { '/' => {} }
    parse_input
  end

  def part_a
    calc_size(file_structure)
    # puts file_structure
    
  end

  private
  attr_accessor :lines, :file_structure, :location

  def parse_input
    lines.each do |line|
      # puts "#{line} | loc: #{location}"
      line = line.split(' ')
      case line[0]
      when '$'
        if line[1] == 'cd'
          line[2] == '..' ? location.pop : location.push(line[2])
        end
      when 'dir'
        file_structure.dig(*location)[line[1]] = {}
      else
        file_structure.dig(*location)[:files] ||= 0
        file_structure.dig(*location)[:files] += line[0].to_i
      end
    end
    # puts file_structure
    # puts "---------------"
  end

  def calc_size(dir)
    dir.each do |name, value|
      unless name == :files
        file_size = calc_size(value)
        dir[:files] += file_size unless dir.keys.size == 1 || dir.keys.first == '/'
      end
    end
    # puts "end calc_size for #{dir}: #{dir[:files]}"
    dir[:files]
  end
end

Day7.new.part_a