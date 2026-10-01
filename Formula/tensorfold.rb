class Tensorfold < Formula
  include Language::Python::Virtualenv

  desc "Fast, exact LLM decoding on Apple silicon behind an OpenAI-compatible endpoint"
  homepage "https://github.com/ashhart/TensorFold"
  url "https://github.com/ashhart/TensorFold/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "eb6f4d8842f697c9b8e0cdcf4bce5200f81aa9dd37fc72a56415595078c2f633"
  license "Apache-2.0"
  head "https://github.com/ashhart/TensorFold.git", branch: "main"

  depends_on arch: :arm64
  depends_on macos: :sonoma
  depends_on "python@3.14"

  def install
    # pip resolves TensorFold's pinned MLX wheels into an environment with no pip of its own, so only brew changes it
    venv = virtualenv_create(libexec, python3, system_site_packages: false)
    system python3, "-m", "pip", "--python=#{venv.root}/bin/python", "install", "--no-cache-dir", "--prefer-binary",
           buildpath
    bin.install_symlink libexec/"bin/tensorfold"
  end

  def caveats
    <<~EOS
      Models download to the Hugging Face cache on first use, for example:
        tensorfold serve Vontra/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-MLX-4bit
      Upgrade with `brew upgrade tensorfold`.
    EOS
  end

  test do
    (testpath/"nemotron/config.json").write <<~JSON
      {"model_type": "nemotron_h", "quantization": {"group_size": 64, "bits": 4}}
    JSON
    output = shell_output("#{bin}/tensorfold info #{testpath}/nemotron")
    assert_match "family       Nemotron 3.5 Lightning", output
    assert_match "runs on      Apple Silicon (MLX)", output
    assert_match "model    Vontra/", shell_output("#{bin}/tensorfold models")
    system libexec/"bin/python", "-c", "import mlx.core as mx; assert (mx.array(2) + 3).item() == 5"
  end
end
