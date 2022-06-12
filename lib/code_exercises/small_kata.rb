def beeramid(bonus, price)
  total = 0
  level = 0
  while total + (((level+1)** 2) * price) <= bonus do
    level += 1
    total += (level ** 2) * price
    puts "Beer #: #{level}, Total += #{(level ** 2) * price }, Total: #{total}"
  end
  level
end

def sudokuer(puzzle)
  puzzle.each { |row|
    row[row.find_index(0)] = row.sort.each_with_index { |n, idx| 
      break idx if n != idx
      break 9 if idx == 8
    }
  }
end

def csv_columns(csv, indices)
  rows = []
  csv.split("\n").each { |col| rows.push(col.split(",")) }
  res = ""
  indices = indices.uniq.sort
  rows.each_with_index { |row, row_idx|
    indices.each { |col_idx| res += col_idx <= row.length - 1 ? "#{res.length == 0 || res[-1] == "\n" ? "" : ","}#{row[col_idx]}" : "" }
    res += ((res == "") || (row_idx == rows.length - 1)) ? "": "\n"
  }
  res
end

def valid_parentheses(string)
  pairs = 0
  string.each_char { |char| 
    pairs += char == '(' ? 1 : char == ')' ? -1 : 0
    return false if pairs < 0
  }
  pairs == 0 ? true : false
end

#4 sku String Mix
def mix(s1, s2)
  s1_chars = {}
  s2_chars = {}
  s1.each_char { |char| s1_chars[char] = s1_chars[char] ? s1_chars[char] + 1 : 1 if char.match('[a-z]')}
  s2.each_char { |char| s2_chars[char] = s2_chars[char] ? s2_chars[char] + 1 : 1 if char.match('[a-z]')}

  chars = s1_chars.keys.concat(s2_chars.keys).uniq
  
  count = {}
  
  for char in chars
    count_s1 = s1_chars[char] ? s1_chars[char] > 1 ? s1_chars[char] : false : false
    count_s2 = s2_chars[char] ? s2_chars[char] > 1 ? s2_chars[char] : false : false
    if count_s1 && count_s2 && count_s1 == count_s2
      count[count_s1] ||= {}
      count[count_s1]['='] ||= []
      count[count_s1]['='].push(char)
    elsif count_s1 && (!count_s2 || count_s1 > count_s2)
      count[count_s1] ||= {}
      count[count_s1]['1'] ||= []
      count[count_s1]['1'].push(char)
    elsif count_s2
      count[count_s2] ||= {}
      count[count_s2]['2'] ||= []
      count[count_s2]['2'].push(char)
    end
  end
  result = []
  count.keys.sort!{ |a, b| b <=> a }.each { |char_count|
    count[char_count].keys.sort!.each { |s_num|
      count[char_count][s_num].sort!.each { |char|
        result.push "#{s_num}:#{char * char_count}"
      }
    }
  }
  result.join('/')
end

def dbl_linear(n)
  u = [1]
  y = []
  z = []
  for x in 0..n
    new_y = 2 * u[x] + 1
    new_z = 3 * u[x] + 1
    y.push(new_y)
    z.push(new_z)
    while (y[0] ? y[0] <= new_y : false) || (z[0] ? z[0] <= new_y : false)
      to_place = y[0] && y[0] <= z[0] ? y.shift : z.shift
      u.push(to_place) unless to_place == u[-1]
      return u[-1] if u.length == n + 1
    end
  end
  u[-1]
end

def last_digit(n1, n2)
  n1 == 0 || n2 == 0 ? 1 : (n1 % 10) ** (n2 % 4 + 4) % 10
end

def sum_of_intervals(intervals)
  intervals.sort!
  total = 0
  for idx in 1...intervals.length
    cur = intervals[idx]
    prev = intervals[idx - 1]
    if cur[0] < prev[1]
      intervals[idx] = [prev[0], cur[1] < prev[1] ? prev[1] : cur[1]]
    else
      total += prev[1] - prev[0]
    end
  end
  total += intervals[-1][1] - intervals[-1][0]
end

#7kyu version, need to finish advanced version
def triangle(row)
  colors = ['R', 'G', 'B']
  while row.length > 1
    new_row = ""
    for idx in 0...row.length-1
      if row[idx] == row[idx+1]
        new_row += row[idx]
      else
        new_row += colors.filter { |color| color != row[idx] && color != row[idx + 1] }[0]
      end
    end
    row = new_row
  end
  row
end

def get_pins(observed)
  key_options = {}
  for i in 0..9
    key_options[i.to_s] = get_key_options(i)
  end  
  combos = []
  observed.each_char do |n|
    new_combos = []
    key_options[n].each do |option|
      if combos.size != 0
        combos.each { |combo| new_combos.push(combo + option)}
      else
        new_combos.push(option)
      end
    end
    combos = new_combos
  end
  combos
end

def get_key_options(n)
  return [0.to_s, 8.to_s] if n == 0
  options = [n.to_s]
  options.push(0.to_s) if n == 8
  remainder = n % 3
  row = (n / 3.0).ceil
  
  options.push((n + 1).to_s) if remainder != 0
  options.push((n - 1).to_s) if remainder != 1
  
  options.push((n + 3).to_s) if row != 3
  options.push((n - 3).to_s) if row != 1
  options
end

def solution(list)
  list_str = ""
  skipped_idx = nil
  (list.length - 1).downto(0) do |idx|
    next if skipped_idx && skipped_idx <= idx
    range = 1
    while list[idx - range - 1] + range + 1 == list[idx] && idx - range - 1 >= 0
      range += 1
    end
    if range > 1
      skipped_idx = idx - range
      list_str = ",#{list[skipped_idx]}-#{list[idx]}" + list_str
    else
      list_str = ",#{list[idx]}" + list_str
    end
  end
  list_str = list_str[1..-1]
end

class Battlefield
  
  def initialize(field)
    @field = field
    @size_ships_to_find = {
      4 => 1,
      3 => 2,
      2 => 3,
      1 => 4
    }
  end
  
  def validate_board
    for y in 0..9
      for x in 0..9
        if @field[y][x] != 0
          valid = check_surroundings(x, y)
          return false unless valid
          p "[#{y}][#{x}] == 1: #{@size_ships_to_find}"
        end
      end
    end
    p @size_ships_to_find
    @size_ships_to_find.values.sum == 0 ? true : false
  end
  
  def check_surroundings(x, y)
    @field[y][x] = 0
    return false unless check_diagonal(x, y)
    horizontal = (x > 0 ? @field[y][x-1] == 1 ? true : false : false) || (x < 9 ? @field[y][x+1] == 1 ? true : false : false)
    vertical   = (y > 0 ? @field[y-1][x] == 1 ? true : false : false) || (y < 9 ? @field[y+1][x] == 1 ? true : false : false)
    return false if horizontal && vertical
    return found_ship(1) if !horizontal && !vertical
    return found_ship(horizontal ? check_horizontal(x, y) : check_vertical(x, y))
  end
  
  def check_diagonal(x, y)
    diag_present = false
    diag_present ||= y > 0 && x > 0 ? @field[y-1][x-1] == 1 : false
    diag_present ||= y > 0 && x < 9 ? @field[y-1][x+1] == 1 : false
    diag_present ||= y < 9 && x > 0 ? @field[y+1][x-1] == 1 : false
    diag_present ||= y < 9 && x < 9 ? @field[y+1][x+1] == 1 : false
    return !diag_present
  end
  
  def check_horizontal(x, y)
    size = 1
    (x - 1).downto(0) do |i|
      @field[y][i] == 1 ? size += 1 : break
      @field[y][i] = 0
      return false unless check_diagonal(x, y)
    end
    (x + 1).upto(9) do |i|
      @field[y][i] == 1 ? size += 1 : break
      @field[y][i] = 0
      return false unless check_diagonal(x, y)
    end
    size
  end
  
  def check_vertical(x, y)
    size = 1
    (y - 1).downto(0) do |i|
      @field[i][x] == 1 ? size += 1 : break
      @field[i][x] = 0
      return false unless check_diagonal(x, y)
    end
    (y + 1).upto(9) do |i|
      @field[i][x] == 1 ? size += 1 : break
      @field[i][x] = 0
      return false unless check_diagonal(x, y)
    end
    size
  end
  
  def found_ship(ship)
    p ship
    return false if ship > 4
    @size_ships_to_find[ship] > 0 ? @size_ships_to_find[ship] -= 1 : false
  end
end

def validate_battlefield(field)
  game = Battlefield.new(field)
  game.validate_board
end

p validate_battlefield( [
  [1, 0, 0, 0, 0, 1, 1, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 0, 0, 1, 0],
  [1, 0, 1, 0, 1, 1, 1, 0, 1, 0],
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
  [0, 0, 0, 0, 1, 1, 1, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
  [0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
])
p validate_battlefield( [
  [1, 0, 0, 0, 0, 1, 1, 0, 0, 0],
  [1, 0, 1, 0, 0, 0, 0, 0, 1, 0],
  [1, 0, 1, 0, 1, 1, 1, 0, 1, 0],
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
  [0, 0, 0, 0, 1, 1, 1, 0, 0, 0],
  [0, 0, 0, 1, 0, 0, 0, 0, 1, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
])

class DurationFormatter
  SEC_MIN  = 60
  SEC_HOUR = 60  * SEC_MIN
  SEC_DAY  = 24  * SEC_HOUR
  SEC_YEAR = 365 * SEC_DAY
  
  @@time_units = [
    ["year", SEC_YEAR],
    ["day",  SEC_DAY],
    ["hour", SEC_HOUR],
    ["minute",  SEC_MIN],
    ["second", 1]
  ]
  
  attr_reader :time

  def initialize(seconds)
    @seconds = seconds
    @time = ""
    format_time
  end
    
  def format_time
    return @time = "now" if @seconds == 0
    @@time_units.each do |unit_name, unit|
      format_unit(unit_name, unit)
      return if @seconds == 0
    end
  end
  
  def format_unit(unit_name, unit)
    return if @seconds < unit
    num_units = @seconds / unit
    @seconds -= num_units * unit
    @time += @time == "" ? "" : @seconds > 0 ? ", " : " and "
    @time += "#{num_units} #{unit_name}#{num_units > 1 ? "s": ""}"
  end
end

def format_duration(seconds)
  DurationFormatter.new(seconds).time
end

def cakes(recipe, available)
  max_cakes = nil
  recipe.each do |ingredient, amt_needed|
    puts "#{ingredient}, #{amt_needed}/#{available[ingredient]}"
    if available[ingredient] == nil
      return 0
    end
    min_possible = available[ingredient] / amt_needed 
    min_possible = min_possible.floor
    puts "#{ingredient}, #{amt_needed}/#{available[ingredient]}, #{min_possible}"
    if max_cakes == nil 
      max_cakes = min_possible
    elsif max_cakes > min_possible 
      max_cakes = min_possible
    end
  end
  
  return max_cakes
  
end

def sumOfDivided(lst)
  result = []
  highest_possible = lst.map { |num| num.abs() }.sort[-1]
  for i in 2..highest_possible
    if is_prime(i)
      sum = 0
      added = false
      lst.each do |num|
        if num % i == 0
          sum += num
          added ||= true
        end
      end
      result.push([i, sum]) if added
    end
  end
  result
end

def is_prime(num)
  for i in 2..(num/2.to_i)
    return false if num % i == 0
  end
  true
end

def count_red_beads n 
  n < 2 ? 0 : (n - 1) * 2
end 

def snail(array)
  return [] if array == [[]]
  return "Array must be n x n" if array.length != array[0].length  
  recurse(array, "right", 0)
end

# Not the most efficent method but a fun one.
def recurse(array, dir, row)
  return array[0] if array.length == 1 && array[0].length == 1
  
  case dir
  when "right"
    res = array.shift
    return res.concat(recurse(array, "down", 0))
  when "down"
    res = [array[row].pop]
    if row == array.length - 2
      return res.concat(recurse(array, "left", row + 1))
    else
      return res.concat(recurse(array, "down", row + 1))
    end
  when "left"
    res = array.pop.reverse
    return res.concat(recurse(array, "up", row - 1))
  when "up"
    res = [array[row].shift]
    if row == 1
      return res.concat(recurse(array, "right", row - 1))
    else
      return res.concat(recurse(array, "up", row - 1))
    end
  end
end

def top_3_words(text)
  text_arr = text.downcase.split(%r{[^a-zA-Z']}).select {
    |word| word.match(%r{.*[a-zA-Z]+.*})
  }
  return [] if text_arr.length == 0
  
  word_count = {}
  count_word = {}
  max = []
  text_arr.each do |word|
    unless word == ''
      word_count[word] ||= 0
      word_count[word] += 1
    end
  end
  
  word_count.each do |word, count|
    count_word[count] ||= []
    count_word[count].push word
  end
  
  (count_word.keys.max).downto(1) { |i|
    count_word[i].each do |word|
      max.push word
      return max if max.length == 3
    end if count_word[i]
  }
  return max
end

def solution(input, markers)
  input.split("\n").map! { |s| s.split(%r{[#{markers.join('')}]})[0].rstrip }.join("\n")
end

def next_bigger(n)
  n_arr = n.to_s.split('')
  swap_idx = -1
  for i in (n_arr.length - 1).downto(1)
    if n_arr[i] > n_arr[i - 1]
      swap_idx = i - 1
      break
    end
  end
  return swap_idx if swap_idx == -1
  
  digit_to_swap = n_arr[swap_idx]
  asc_sorted_digits = n_arr.slice!(swap_idx...n_arr.length).sort
  next_higher_digit = asc_sorted_digits.slice!(
    asc_sorted_digits.find_index { |x| x > digit_to_swap }
  )
  
  n_arr.push(next_higher_digit).push(asc_sorted_digits).join().to_i
end

function multiply(n, o){
  var n_vals = new Map();
  var o_vals = new Map();
  
  n_vals = preprocess(n_vals, n);
  o_vals = preprocess(o_vals, o);
  
  int_str = String(n_vals['int'] * o_vals['int']);
  if (int_str == "0") {
    return int_str;
  }
  
  place_decimal(int_str, n_vals, o_vals);
  
  neg = n_vals['is_negative'] == o_vals['is_negative'] ? '' : '-';
  actual_str = actual_str.indexOf('.') >= 0 ? trim_trailing_zeroes(actual_str, true) : actual_str
  return neg + actual_str;
}

function place_decimal(int_str, n_vals, o_vals) {
  decs = n_vals['dec_idx'] + o_vals['dec_idx'];
  
  if (decs > int_str.length + 1) {
    int_str = "0".repeat(decs - int_str.length + 1) + int_str;
  }
  
  actual_str = decs > 0 ? int_str.slice(0, -decs) + '.' + int_str.slice(-decs): int_str;
  neg = n_vals['is_negative'] == o_vals['is_negative'] ? '' : '-';
  return 
}

function preprocess(n_vals, n) {
  n = n.trim();
  n_vals['is_negative'] = is_negative(n);
  n = n_vals['is_negative'] ? n.slice(1) : n;
  n = trim_zeroes(n, n.indexOf('.') >= 0);
  n_vals['orig'] = n;
  
  const dec_idx = n.indexOf('.');
  n_vals['is_float'] = dec_idx >= 0;
  n_vals['dec_idx'] = n_vals['is_float']  ? n.length - dec_idx -1 : 0;
  n_vals['int'] = BigInt(dec_idx >= 0 ? n.slice(0, dec_idx).concat(n.slice(dec_idx + 1)) : n);
  return n_vals
}

function is_negative(n) {
  return n.trimStart().charAt(0) == "-";
}

function trim_zeroes(n, has_decimal) {
  n = trim_leading_zeroes(n);
  return has_decimal ? trim_trailing_zeroes(n, has_decimal) : n;
}

function trim_leading_zeroes(n) {
  var slice = 0;
  for (var i = 0; i < n.length; i++) {
    if (n.charAt(i) == "0") {
      slice += 1;
    } else {
      break;
    }
  }
  return slice ? n.slice(slice) : n;
}

function trim_trailing_zeroes(n, has_decimal) {
  var slice = false;
  for (var i = n.length - 1; i >= 0; i--) {
    if (n.charAt(i) == "0") {
      slice = slice ? slice - 1 : n.length - 1;
    } else {
      break;
    }
  }
  
  n = slice ? n.slice(0, slice) : n;
  
  if (has_decimal && n.indexOf('.') == n.length - 1) {
    n = n.slice(0, -1);
  }
  
  return n;
}

def is_interesting(number, awesome_phrases)
  return 0 unless number >= 98
  range = number < 100 ? number - 97 : 2
  num_str = number.to_s
  
  awesome = check_awesome_phrase(number, awesome_phrases)
  return awesome if awesome == 2
  
  pal = check_palindrome(num_str)
  return pal if pal == 2
  
  interesting = check_interesting(num_str) ? 2 : nil
  return interesting if interesting == 2
  
  interesting = check_interesting((number + 1).to_s) ? 1 : nil
  interesting ||= check_interesting((number + 2).to_s) ? 1 : nil
  
  result = [awesome, interesting, pal].compact.max
  
  return result ? result : 0
end

def check_awesome_phrase(number, awesome_phrases)
  awesome_phrases.each do |phrase|
    if number == phrase
      return 2
    elsif (phrase - number).abs <= 2
      return 1
    end
  end
  return nil
end

def check_interesting(num_str)
  return nil if num_str.to_i < 100
  all_zeroes = true
  all_same = true
  incr = true
  decr = true

  for i in 1...num_str.length
    cur = num_str[i].to_i
    prev = num_str[i-1].to_i
    
    all_zeroes &&= cur == 0
    all_same &&= prev == cur
    incr &&= (prev + 1) % 10 == cur
    decr &&= (prev - 1) % 10 == cur
  end
  
  return (all_zeroes || all_same || incr || decr) ? true : nil
end

def check_palindrome(num_str)
  if num_str[0] == num_str[-1] && num_str.to_i >= 100
    return recurse_palindrome(num_str[1..-2]) ? 2 : nil
  elsif (num_str[0].to_i - num_str[-1].to_i) % 10 <= 2
    if num_str[-1].to_i == 9
      num_str[-2] = ((num_str[-2].to_i + 1) % 10).to_s
      return recurse_palindrome(num_str[1..-2], true) ? 1 : nil
    else
      return recurse_palindrome(num_str[1..-2]) ? 1 : nil
    end
  else
    return nil
  end
end

def recurse_palindrome(num_str, check_last_digit=false)
  return true if num_str.length <= 1
  if num_str[0] == num_str[-1]
    if check_last_digit && num_str[-1] == 0
      num_str[-2] = ((num_str[-2].to_i + 1) % 10).to_s
      return recurse_palindrome(num_str[1..-2], true)
    else
      return recurse_palindrome(num_str[1..-2])
    end
  end
  return nil
end

def validSolution(board)
  return false unless board.length == 9 && board[0].length == 9
  return false unless validate_two_d_array(board)
  columns, blocks = get_data(board)
  validate_two_d_array(columns) && validate_two_d_array(blocks)
end

def get_data(board)
  columns = []
  blocks = []
  for y in 0...9
    for x in 0...9
      columns[x] ||= []
      columns[x].push(board[y][x])
      
      block_no = x.div(3) + (y.div(3) * 3)
      blocks[block_no] ||= []
      blocks[block_no].push(board[y][x])
    end
  end
  [columns, blocks]
end

def validate_two_d_array(two_d_arr)
  two_d_arr.each do |arr|
    sorted = arr.sort.uniq
    return false if sorted[0] != 1 || sorted[8] != 9
  end
  true
end

def descending_order(n)
  return unless n >= 0
  n.to_s.split('').sort { |a, b| b <=> a }.join('').to_i
end

def solution(number)
  sum = 0
  (0...number).each { |i| sum += (i % 3 == 0 || i % 5 == 0) ? i : 0 }
  sum
end