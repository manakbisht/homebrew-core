class Frawk < Formula
  desc "an efficient awk-like language"
  homepage "https://github.com/ezrosent/frawk"
  url "https://github.com/ezrosent/frawk/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "7ec5d93f3a9ee3c4bafc7db790ea471a568e94de657fbb74d7a3b641bf3e68e6"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
     url :stable
     strategy :github_latest
   end

  depends_on "llvm@12" => :build
  depends_on "rustup-init" => :build

  def install
    system "echo", "nightly", ">", "#{buildpath}/rust-toolchain"
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.csv").write <<~EOS
      Item,Quantity
      Carrot,2
      "The Deluge: The Great War, America and the Remaking of the Global Order, 1916-1931",3
      Banana,4
    EOS
    output = pipe_output("#{bin}/frawk --i csv 'NR>1 { SUM+=$2 } END { print SUM }'")
    assert_equal "9", output.strip
  end
end
