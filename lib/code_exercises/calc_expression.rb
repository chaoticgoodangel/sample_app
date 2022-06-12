# class ExpressionCalculator

#   def initialize(expression)
#     @exp = expression
#     @paren_pairs = find_parens
#   end

#   def calculate
#     eval_parens if @paren_pairs.length > 0
#     eval_exp(@exp)
#   end

#   def find_parens
#     paren_pairs = []
#     level = 0
#     level_pairs = []
#     for idx in 0...@exp.length
#       case @exp[idx]
#       when "("
#         level_pairs[level] ||= []
#         level_pairs[level].push(idx)
#         paren_pairs.push({ open: idx, level: level, children: [] })
#         if level > 0 && level_pairs[level - 1].length > 0
#           pair = paren_pairs.select{ |pair| pair[:open] == level_pairs[level - 1][0] }[0]
#           pair[:children] ||= []
#           pair[:children].push(idx)
#         end
#         level += 1
#       when ")"
#         (paren_pairs.length - 1).downto(0) do |i|
#           level_pairs[paren_pairs[i][:level]].pop
#           break paren_pairs[i][:closed] = idx unless paren_pairs[i][:closed]
#         end
#         level -= 1
#       end
#     end
#     paren_pairs
#   end

#   def eval_parens
#     max_level = @paren_pairs[0][:level]
#     @paren_pairs.sort { |a, b| b[:level] <=> a[:level] }.each do |pair|
#       paren_exp = @exp[(pair[:open] + 1)..(pair[:closed] - 1)]
#       pair[:children].reverse.each do |child_open_idx|
#         child = get_pair_by_val(open: child_open_idx)[0]
#         paren_exp.slice!((child[:open] - pair[:open] - 1)..(child[:closed] - pair[:open] - 1))
#         paren_exp.insert(child[:open] - pair[:open] - 1, child[:val])
#       end if pair[:children].length > 0
#       puts "paren_exp after all replaced: #{paren_exp}"
#       pair[:val] = eval_exp(paren_exp)
#     end

#     puts "After eval_parens main loop #{@paren_pairs}"

#     get_pair_by_val(level: 0).sort{ |a, b| b[:open] <=> a[:open] }.each do |pair|
#       puts @exp
#       puts pair[:open]
#       puts pair[:closed]
#       @exp.slice!((pair[:open])..(pair[:closed]))
#       puts "after slice #{@exp} with #{pair[:open]} #{pair[:closed]}"

#       @exp.insert(pair[:open], pair[:val])
#       puts @exp

#     end
#   end

#   def get_pair_by_val(open: nil, closed: nil, level: nil)
#     return false unless open || closed || level
#     @paren_pairs.select{ |pair| 
#       open ? pair[:open] == open : false ||
#       closed ? pair[:closed] == closed : false ||
#       level ? pair[:level] == level : false
#     }
#   end

#   def eval_exp(exp)
#     print "exp == @exp " if @exp == exp
#     puts "in eval_exp: #{exp}"
#     mult_div_vals = []
#     for idx in 0..exp.length-1
#       if exp[idx] == "*" || exp[idx] == "/"
#         left_most = (idx - 1).downto(0) { |i| 
#           break i 0 if i == 0
#           break i + 1 if "*/+-".include? exp[i] 
#         }
#         right_most = (idx + 1).upto(exp.length-1) { |i| 
#           break i if i == exp.length - 1
#           break i - 1 if "*/+-".include? exp[i] 
#         }
#         left = exp.slice(left_most...idx).to_f
#         right = exp.slice(idx + 1..right_most).to_f
#         mult_div_vals.push( {
#           open: left_most,
#           closed: right_most,
#           value: exp[idx] == "*" ? left * right : left / right
#         })
#       end
#     end
#     puts "in mult_div_vals: #{mult_div_vals} #{exp[mult_div_vals[0][:open]]} #{exp[mult_div_vals[0][:closed]]} " if mult_div_vals.length > 0

#     (mult_div_vals.length - 1).downto(0) do |idx|
#       mult_div = mult_div_vals[idx]
#       exp.slice!(mult_div[:open]..mult_div[:closed])
#       exp.insert(mult_div[:open], mult_div[:value].to_s)
#     end if mult_div_vals.length > 0

#     add_sub_vals = []
#     for idx in 1..exp.length-1
#       if exp[idx] == "+" || exp[idx] == "-"
#         if exp[idx] < exp.length - 2 && exp[idx + 1] == "-"
#           idx += 1
#         else
#           left_most = (idx - 1).downto(0) { |i| 
#             break i if i == 0
#             break i + 1 if "+-".include? exp[i] 
#           }
#           right_most = (idx + 1).upto(exp.length-1) { |i| 
#             break i if i == exp.length - 1
#             break i - 1 if "+-".include? exp[i] 
#           }
#           left = exp.slice(left_most...idx).to_f
#           right = exp.slice(idx + 1..right_most).to_f
#           add_sub_vals.push( {
#             open: left_most,
#             closed: right_most,
#             value: exp[idx] == "+" ? left + right : left - right
#           })
#         end
#       end
#     end
#     puts "in add_sub_vals: #{add_sub_vals} #{exp[add_sub_vals[0][:open]]} #{exp[add_sub_vals[0][:closed]]} " if add_sub_vals.length > 0

#     (add_sub_vals.length - 1).downto(0) do |idx|
#       add_sub = add_sub_vals[idx]
#       exp.slice!(add_sub[:open]..add_sub[:closed])
#       exp.insert(add_sub[:open], add_sub[:value].to_s)
#     end if add_sub_vals.length > 0

#     exp
#   end
# end

# def calc(expression)
#   calculator = ExpressionCalculator.new(expression)
#   calculator.calculate
# end
# puts "calc: #{calc("( 1 * 2 ) * 3")}" 

def calc(expression)
  puts "At beginning!! #{expression}"
  data = str_to_arr(expression)
  eval_data(data)
  parens = find_parens(expression)
  (parens.length - 1).downto(0) do |level|
    parens[level].each do |paren|
      paren, expression = calculate_paren(paren, expression)
    end
  end
end

def find_parens(expression)
  parens = [[]]
  level = 0
  paren_count = 0
  exp = ""
  for i in 0..expression.length - 1
    # parens.each do |paren|
    #   paren[:exp] ||= ""
    #   paren[:exp] += expression[i] unless paren[:close]
    # end
    if expression[i] == "(" || expression[i] == ")"
      paren_count += 1
    
      if expression[i] == "("
        parens[level] ||= []
        parens[level].push({open: i})
        level += 1
      elsif expression[i] == ")"
        level -= 1
        found = false
        (parens.length - 1).downto(0) do |level_idx|
          break if found
          (parens[level_idx].length - 1).downto(0) do |exp_idx|
            unless parens[level_idx][exp_idx][:close]
              parens[level_idx][exp_idx][:close] = i
              #parens[idx][:exp].slice!(-1)
              found = true
              break
            end
          end
        end
      end
    end
  end
  parens.each { |paren| p paren }
  parens
end

def calculate_paren(paren, expression)
  p paren
  str_len = paren[:close] - paren[:open] + 1
  p expression.slice(paren[:open]..paren[:close])
  [paren, expression]
end

def str_to_arr(expression)
  data = {
    exp_arr: [],
    paren_pairs: [],
    mult_div: [],
    add_sub: [],
  }
  cur_num = ""
  
  while expression[0] == "(" && expression[-1] == ")"
    expression = expression.slice(1..-2)
  end
  
  expression.each_char do |char|
    neg = false
    next if char.strip.empty?
    if char == "-" && cur_num == ""
      cur_num += "-"
      next
    elsif "()*/+-".include? char
      if char == "(" && cur_num == "-"
        neg = true
      else
        data[:exp_arr].push(cur_num.to_f) unless cur_num == ""
      end
      cur_num = ""
      data[:exp_arr].push(char)
    end

    index = data[:exp_arr].length - 1

    case char
    when "("
      data[:paren_pairs].push({open: index})
      data[:paren_pairs][-1][:neg] = neg
    when ")"
      (data[:paren_pairs].length - 1).downto(0) { |i|
        unless data[:paren_pairs][i][:close]
          data[:paren_pairs][i][:close] = index
          break
        end
      }
    when "*", "/"
      data[:mult_div].push(index)
    when "+", "-"
      data[:add_sub].push(index)
    else
      cur_num += char
    end
  end
  data[:exp_arr].push(cur_num.to_f) unless cur_num == ""
  return data
end

def eval_data(data)
  puts
  puts "Start eval_data ##{@@count}: #{data}"
  @@count += 1
  puts
  while data[:paren_pairs].length > 0
    paren_idxs = data[:paren_pairs].shift
    new_data = get_new_data(data, paren_idxs[:open] + 1, paren_idxs[:close] - 1)
    p "Evaluating new_data: #{new_data}"
    result = eval_data(new_data)
    result = -result if paren_idxs[:neg]
    p "Result: #{result}"
    p paren_idxs
    p data
    update_data(data, paren_idxs[:open], paren_idxs[:close], result)
    puts "Data updated w/ result: #{data}"
    puts
  end
  
  while data[:mult_div].length > 0
    index = data[:mult_div][0]
    op = data[:exp_arr][index]
    left = data[:exp_arr][index - 1]
    right = data[:exp_arr][index + 1]
#     puts "op: #{op}"
#     puts "left: #{left}"
#     puts "right: #{right}"
    result = op == "*" ? left * right : left / right
    data[:mult_div].shift
    update_data(data, index-1, index+1, result)
  end
  
  while data[:add_sub].length > 0
     puts "Add_sub 'index': #{data[:add_sub]} #{data[:add_sub][0]}"
    index = data[:add_sub][0]
    op = data[:exp_arr][index]
    left = data[:exp_arr][index - 1]
    right = data[:exp_arr][index + 1]
#     puts "op: #{op}"
#     puts "left: #{left}"
#     puts "right: #{right}"
    result = op == "+" ? left + right : left - right
    data[:add_sub].shift
    update_data(data, index-1, index+1, result)
  end
  
  fail if data[:exp_arr].length > 1
  puts "In return: #{data}"
  return data[:exp_arr][0]
end
    
def get_new_data(data, start_idx, end_idx)
#   p "Get new data from #{start_idx} to #{end_idx}"
  new_data = {}
  data.each do |key, value|
#     p "Loop on #{key}: #{value}"
    case key
    when :exp_arr
      new_data[key] = data[key].slice(start_idx..end_idx)
    when :paren_pairs
      new_data[key] = data[key].select { |pair| 
        pair[:open].between?(start_idx, end_idx) && pair[:close].between?(start_idx, end_idx)
      }
#       p "New data: #{new_data[key]}"
      new_data[key].map! { |pair| 
#         pair.each_pair { |pos, idx| 
#           p pos
#           p idx
#           pair[pos] = idx - start_idx 
#         }
        pair[:open] = pair[:open] - start_idx
        pair[:close] = pair[:close] - start_idx
        pair
      }
    else
      new_data[key] = data[key].select { |val| val.between?(start_idx, end_idx)}.map! { |val| val - start_idx }
    end
  end
#   p "New data: #{new_data}"
  return new_data
end

def update_data(data, start_idx, end_idx, result)
#  puts "\nIn update data: #{data}"
  
  replace_len = end_idx - start_idx
  data.each do |key, value|
    case key
    when :exp_arr
      data[key].slice!(start_idx..end_idx)
      data[key].insert(start_idx, result)
    when :paren_pairs
#       puts "In paren_pairs: #{data}"
#       puts "data[key] = #{data[key]}"
#       puts "Start - End: #{start_idx} - #{end_idx}"
#       puts "Replace_len = #{replace_len}"
      data[key].map { |pair| 
        pair.each_pair { |pos, idx| 
          pair[pos] = idx - replace_len if pos != :neg && idx > end_idx
        } 
      }
    else
      #puts "Start: #{start_idx} End: #{end_idx} Key: #{key} Value: #{data[key]}" 
      (data[key].length - 1).downto(0) { |i|
        if data[key][i].between?(start_idx, end_idx)
          data[key].delete_at(i)
        elsif data[key][i] > end_idx
          #puts "in if"
          data[key][i] -= replace_len
        end
      } if data[key].length > 0
      #puts "After update Key: #{key} Value: #{data[key]}" 
    end
  end
#  puts "After update data: #{data}"
#   puts
end

puts "calc: #{calc("(1 * 2) * 3")}" 
puts "calc: #{calc("(1 + 2) - 3 * 4 + (55 / 22)")}"
puts "calc: #{calc("12* 123/-(-5 + 2)")}"
puts "calc: #{calc("((80 - ((19))))")}"
puts "calc: #{calc("((80)-((-19)))")}"
# puts "calc: #{calc("1+(2+((3+4)+(5+(6))))+(7)")}"
# 1 + ( 2 +  (  (  3 + 4 ) + (   5   +  ( 6  )  )  )  ) + (  7  )
# 0 1 2 3 4  5  6  7 8 9 10  12  13  14 15   17 18 19 20  21   22
tests = [
  ['1+1', 2],
  ['1 - 1', 0],
  ['1* 1', 1],
  ['1 /1', 1],
  ['-123', -123],
  ['123', 123],
  ['2 /2+3 * 4.75- -6', 21.25],
  ['12* 123', 1476],
  ['2 / (2 + 3) * 4.33 - -6', 7.732]
]

# tests.each do |pair|
#   puts calc(pair[0]) == pair[1]
# end