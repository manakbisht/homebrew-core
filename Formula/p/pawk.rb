class Pawk < Formula
  include Language::Python::Shebang

  desc "Python line processor (like AWK)"
  homepage "https://github.com/alecthomas/pawk"
  url "https://github.com/alecthomas/pawk/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "727955d22f0f88ed06443fda067d67d637373cb7dd9debf01ffa3db5b8f907f4"
  license "MIT"

  uses_from_macos "python"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "pawk.py"
    bin.install "pawk.py" => "pawk"
  end

  test do
    (testpath/"elements.txt").write <<~EOS
      # Symbol Name
      H  Hydrogen
      He Helium
      Li Lithium
    EOS
    output = pipe_output("#{bin}/pawk -B 'd={}' -E 'json.dumps(d)' '!/^#/ d[f[1]] = f[0]' < elements.txt")
    assert_equal '{"Hydrogen": "H", "Helium": "He", "Lithium": "Li"}', output.strip
  end
end
