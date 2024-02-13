class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.20.0.tar.gz"
  sha256 "e09eecc669e6c051e465a712ba1b6938300e3a036291cee99c4b1a9b6737143c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2eaaa5275fbec119a3b637120a3b8ee02915e39062de03fd16c3ad6a8fc2c59b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "404a83a1fa7502f4a47f3762e7cfbfad5e4147ec5e7e0aa3bb1740a143b80947"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e1698cd79b721879b5152eb39d50d65a55cc3e31d6f87a105b5cb1b2bda130e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a688eeaa817a5dfd9095ab2d1c5c6544b37882eb39068b67d113cc32f8585431"
    sha256 cellar: :any_skip_relocation, ventura:        "a301b459a4d5efc2a04f4124b4d4e564c23f103db289f20cac9505f302b3579b"
    sha256 cellar: :any_skip_relocation, monterey:       "71ff32429c79bbf12d748593bf7490f8c17ec8f5b9f079f522b6b9d0228d8406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44a2e73dc97b096729076cba369b4633930be0bac157653fca52771d3717c609"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
