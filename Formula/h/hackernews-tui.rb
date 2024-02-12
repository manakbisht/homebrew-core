class HackernewsTui < Formula
  desc "Terminal UI to browse Hacker News"
  homepage "https://github.com/aome510/hackernews-TUI"
  url "https://github.com/aome510/hackernews-TUI/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "77abc579f58ed33905f00eb4d6047b1d7f30a0b4ed98b44b36ff95648c6ebae0"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(root: ".", path: "hackernews_tui")
    bin.install "bin/hackernews_tui" => "hackernews-tui"
  end

  test do
    system "#{bin}/hackernews-tui", "--version"
  end
end
