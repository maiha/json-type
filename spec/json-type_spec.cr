require "./spec_helper"

macro guess(klass, buf)
  it "guess {{klass.id}}" do
    File.write("vals.txt", {{buf}})
    run("./bin/json-type vals.txt").stdout.chomp.should eq({{klass}})
  end
end

describe "json-type" do
  guess "Int32", <<-EOF
    0
    1
    EOF

  guess "Float64", <<-EOF
    0.1
    1.2
    EOF

  guess "Int32 | Nil", <<-EOF
    0
    null
    EOF

  guess "Float64 | Int32 | String", <<-EOF
    "--"
    0
    0.1
    EOF

  it "fails with crystal error when invalid json data exist" do
    File.write("vals.txt", "xxx")
    shell = Shell::Seq.run("./bin/json-type vals.txt")
    shell.success?.should eq(false)
    shell.stderr.should match(/undefined local variable or method 'xxx'/)
  end
end
