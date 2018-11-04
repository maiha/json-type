def process_null(v) : String
  case v
  when "", "null"
    "nil"
  else
    v
  end
end

def build_crystal_code(ary : Array(String)) : String
  String.build do |io|
    io << "a = ["
    ary.each_with_index do |v,i|
      io << v
      io << "," if i < ary.size - 1
      io.puts
    end
    io.puts "]"
    io.puts %|puts a.class.to_s.sub(/^Array\\((.*?)\\)$/,"\\\\1")|
  end
end
