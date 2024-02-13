require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.52.tgz"
  sha256 "4e1c4cd5ccdab8c0d3b09ced231b4a1f9a668a3d77d3f51b0fa196cf4d537a7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8242010183f65c55dca9a7430c8113987aadd89f3325afcb4320944810530e82"
    sha256 cellar: :any, arm64_ventura:  "8242010183f65c55dca9a7430c8113987aadd89f3325afcb4320944810530e82"
    sha256 cellar: :any, arm64_monterey: "8242010183f65c55dca9a7430c8113987aadd89f3325afcb4320944810530e82"
    sha256 cellar: :any, sonoma:         "3fd8ccf6caaa976c51e6fa08b4e638ae41c7754aa4a0d56393f3f3fa7a1422d1"
    sha256 cellar: :any, ventura:        "3fd8ccf6caaa976c51e6fa08b4e638ae41c7754aa4a0d56393f3f3fa7a1422d1"
    sha256 cellar: :any, monterey:       "3fd8ccf6caaa976c51e6fa08b4e638ae41c7754aa4a0d56393f3f3fa7a1422d1"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
