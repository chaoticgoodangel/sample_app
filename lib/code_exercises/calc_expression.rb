class ExpressionCalculator
  attr_accessor :exp, :paren_pairs

  def initialize(expression)
    @exp = expression
    @paren_pairs = find_parens
  end

  def calculate
    puts paren_pairs
    eval_parens
    print "After eval_parens: "
    puts exp
    res = eval_exp(exp)
    res.to_i == res.to_f ? res.to_i : res.to_f
  end

  def find_parens
    paren_pairs = []
    level = 0
    level_pairs = []
    for idx in 0...exp.length
      case exp[idx]
      when "("
        level_pairs[level] ||= []
        level_pairs[level].push(idx)
        paren_pairs.push({ open: idx, level: level, children: [] })
        if level > 0 && level_pairs[level - 1].length > 0
          pair = paren_pairs.select{ |pair| pair[:open] == level_pairs[level - 1][0] }[0]
          pair[:children] ||= []
          pair[:children].push(idx)
        end
        level += 1
      when ")"
        (paren_pairs.length - 1).downto(0) do |i|
          level_pairs[paren_pairs[i][:level]].pop
          break paren_pairs[i][:closed] = idx unless paren_pairs[i][:closed]
        end
        level -= 1
      end
    end
    paren_pairs
  end

  def eval_parens
    return if paren_pairs.length == 0
    max_level = paren_pairs[0][:level]
    paren_pairs.sort { |a, b| b[:level] <=> a[:level] }.each do |pair|
      puts pair
      paren_exp = exp[(pair[:open] + 1)..(pair[:closed] - 1)]
      pair[:children].reverse.each do |child_open_idx|
        child = get_pair_by_val(open: child_open_idx)[0]
        paren_exp.slice!((child[:open] - pair[:open] - 1)..(child[:closed] - pair[:open] - 1))
        paren_exp.insert(child[:open] - pair[:open] - 1, child[:val])
      end if pair[:children].length > 0
      pair[:val] = eval_exp(paren_exp)
    end

    get_pair_by_val(level: 0).sort{ |a, b| b[:open] <=> a[:open] }.each do |pair|
      exp.slice!((pair[:open])..(pair[:closed]))
      exp.insert(pair[:open], pair[:val])
    end
  end

  def get_pair_by_val(open: nil, closed: nil, level: nil)
    return false unless open || closed || level
    paren_pairs.select{ |pair| 
      open ? pair[:open] == open : false ||
      closed ? pair[:closed] == closed : false ||
      level ? pair[:level] == level : false
    }
  end

  def eval_exp(expr)
    ops(expr, "*/")
    ops(expr, "+-")
  end

  def ops(expr, type)
    puts "Beginning of ops: #{expr} #{type}"
    ops_vals = []
    idx = type == "+-" ? 1 : 0
    while idx < expr.length - 1
      if type.include? expr[idx]
        left_most = (idx - 1).downto(0) { |i| 
          break i if i == 0
          break i + 1 if "*/+-".include? expr[i] 
        }
        valid = false
        right_most = (idx + 1).upto(expr.length-1) { |i|
          valid ||= !" -".include?(expr[i])
          break i if i == expr.length - 1
          break i - 1 if valid && "*/+-".include?(expr[i])
        }
        if ops_vals.length > 0 && (left_most <= ops_vals[-1][:closed])
          combo = ops_vals.pop
          left = combo[:value]
          left_most = combo[:open]
        else
          left = extract_num_from_str(expr.slice(left_most...idx))
        end
        right = extract_num_from_str(expr.slice(idx + 1..right_most))
        puts "Left: #{left}, Right: #{right}, rmost: #{right_most}, r_raw: #{expr.slice(idx + 1..right_most)}"
        ops_vals.push( {
          open: left_most,
          closed: right_most,
          value: type == "+-" ? (expr[idx] == "+" ? left + right : left - right) 
                              : (expr[idx] == "*" ? left * right : left / right)
        })
        idx = right_most
      else
        idx += 1
      end
    end

    (ops_vals.length - 1).downto(0) do |idx|
      ops = ops_vals[idx]
      expr.slice!(ops[:open]..ops[:closed])
      expr.insert(ops[:open], ops[:value].to_s)
    end if ops_vals.length > 0
    expr
  end

  def extract_num_from_str(str)
    num_idx = str.index(/[0-9]/)
    puts str
    puts num_idx
    str[0...num_idx].count("-") % 2 == 1 ? str[num_idx..-1].to_f * -1 : str[num_idx..-1].to_f
  end
end

def calc(expression)
  puts expression
  calculator = ExpressionCalculator.new(expression)
  calculator.calculate
end

tests = [
  # ["( 1 * 2 ) * 3", 6],
  # ['(1 + 2) - 3 * 4 + (55 / 22)', (1 + 2) - 3 * 4 + (55 / 22.0)],
  # ['((80 - ((19))))', ((80 - ((19))))],
  # ['(80)-((-19))', (80)-((-19))],
  # ['1+(2+((3+4)+(5+(6))))+(7)', 1+(2+((3+4)+(5+(6))))+(7)],
  # ['1+1', 2],
  # ['1 - 1', 0],
  # ['1* 1', 1],
  # ['1 /1', 1],
  # ['-123', -123],
  # ['123', 123],
  # ['2 * 2 *3 *34', 408],
  # ['2 /2+3 * 4.75- -6', 21.25],
  # ['12* 123', 1476],
  # ['2 / (2 + 3) * 4.33 - -6', 7.732],
  # ['12* 123/-(-5 + 2)', 492],
  ['(1 - 2) + -(-(-(-4)))', (1 - 2) + -(-(-(-4)))],
  # ['12*-1', -12]
]

success = true
str = ""
tests.each do |pair|
  str = "#{pair[0]} = "
  success = calc(pair[0]) == pair[1]
  str += "#{pair[1].to_s}. Got #{pair[0]}"
  break if !success
end
puts success ? "Congrats uwu" : str
