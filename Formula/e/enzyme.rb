class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.101.tar.gz", using: :homebrew_curl
  sha256 "6df0951fa82bfc8654a8ea98202d7fba71212808ce750ca878c71a1854468e12"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9b5d29c7846e93ab6feb8b6a0ef20b2bef25e1a950f4b3675cf4a34f2793a801"
    sha256 cellar: :any,                 arm64_ventura:  "969b29d0e0b17c0cc569ee2bf5ea59e9cf183aec1cde165f2ac523442d42ea03"
    sha256 cellar: :any,                 arm64_monterey: "1dc5c5f6b44334aabbec3cd02b39a539ffaa2fcb73635f9d582e534a3e12b681"
    sha256 cellar: :any,                 sonoma:         "eb4e1ed645fcda4069289a398731cb9f4f678412cdbc7e0a075805913a103c9c"
    sha256 cellar: :any,                 ventura:        "358f9359e428a5dde4a08c021fadd7f91353798318229dcc4b12a51934c4a6a6"
    sha256 cellar: :any,                 monterey:       "1174fdba8fc51afc682b9057932895f3c2cb285e229e2c0486329772ad86c3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be0d7c2c1fde087390e8fb5c6a9acec078eb31ab613f615d8a42d77860c8dfc"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    EOS

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
