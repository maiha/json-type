require "shell"
require "shard"
require "./json-type/helper"

src = "./json-type-guess.cr"

if ARGV.delete("--version")
  puts Shard.git_description
  exit 0
end

path = ARGV.shift? || abort "usage: type-guess file"
vals = File.read_lines(path).sort.uniq

vals = vals.map{|v| process_null(v)}
File.write(src, build_crystal_code(vals))

shell = Shell::Seq.run("crystal #{src}")

if shell.success?
  puts shell.stdout
else
  abort shell.stderr
end
