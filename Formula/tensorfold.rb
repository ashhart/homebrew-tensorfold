class Tensorfold < Formula
  desc "Native TensorFold inference server for Apple Silicon"
  homepage "https://github.com/ashhart/TensorFold"
  url "https://github.com/ashhart/TensorFold/releases/download/v1.1.2/tensorfold-1.1.2-macos-arm64.tar.gz"
  sha256 "c12dabe261e336f187daedc4b36a04e1e29db07507d9a8c3ad16197d1a5c798d"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on macos: :ventura

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/tensorfold-native" => "tensorfold-native"
    bin.install_symlink libexec/"bin/tensorfold-native" => "tensorfold"
  end

  def caveats
    <<~EOS
      Download a model, then serve it:
        tensorfold pull TensorFold/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-MLX-4bit
        tensorfold serve TensorFold/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-MLX-4bit
      The Python engine stays available as `brew install ashhart/tensorfold/tensorfold@0.6`.
    EOS
  end

  test do
    assert_equal "tensorfold-native #{version}", shell_output("#{bin}/tensorfold-native --version").strip
    assert_match "serve MODEL", shell_output("#{bin}/tensorfold --help")
    assert_path_exists libexec/"lib/libtfgrammar.dylib"
  end
end
