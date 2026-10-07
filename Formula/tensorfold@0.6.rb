class TensorfoldAT06 < Formula
  include Language::Python::Virtualenv

  desc "Fast, exact LLM decoding on Apple silicon behind an OpenAI-compatible endpoint"
  homepage "https://github.com/ashhart/TensorFold"
  url "https://github.com/ashhart/TensorFold/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "cdf6b1603a43bd6b8e2786bb89d218554e271903ec63c152aa8097b87166aa9c"
  license "Apache-2.0"

  keg_only :versioned_formula

  depends_on arch: :arm64
  depends_on macos: :sonoma
  depends_on "python@3.14"

  def install
    # pip resolves TensorFold's pinned MLX wheels into an environment with no pip of its own, so only brew changes it
    # the tui extra is installed too: `tensorfold tui` needs it and this environment cannot add it later
    venv = virtualenv_create(libexec, python3, system_site_packages: false)
    system python3, "-m", "pip", "--python=#{venv.root}/bin/python", "install", "--no-cache-dir", "--prefer-binary",
           "#{buildpath}[tui]"
    bin.install_symlink libexec/"bin/tensorfold"
  end

  def caveats
    <<~EOS
      Models download to the Hugging Face cache on first use, for example:
        tensorfold serve TensorFold/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-MLX-4bit
      This is the Python engine at 0.6.6. The native engine is `brew install ashhart/tensorfold/tensorfold`.
    EOS
  end

  test do
    (testpath/"nemotron/config.json").write <<~JSON
      {"model_type": "nemotron_h", "quantization": {"group_size": 64, "bits": 4}}
    JSON
    output = shell_output("#{bin}/tensorfold info #{testpath}/nemotron")
    assert_match "family       Nemotron 3.5 Lightning", output
    assert_match "runs on      Apple Silicon (MLX)", output
    assert_match "model    TensorFold/", shell_output("#{bin}/tensorfold models")
    system libexec/"bin/python", "-c", "import mlx.core as mx; assert (mx.array(2) + 3).item() == 5"
  end
end
