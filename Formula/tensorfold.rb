class Tensorfold < Formula
  desc "Native TensorFold inference server for Apple Silicon"
  homepage "https://github.com/ashhart/TensorFold"
  url "https://github.com/ashhart/TensorFold/releases/download/v1.0.5/tensorfold-1.0.5-macos-arm64.tar.gz"
  sha256 "0fa38f5765725ed727b3c3511aebbdc2b5851034d09164d0d63731612176f7b0"
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
  end
end
