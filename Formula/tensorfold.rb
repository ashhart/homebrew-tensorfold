class Tensorfold < Formula
  desc "Native TensorFold inference server for Apple Silicon"
  homepage "https://github.com/ashhart/TensorFold"
  url "https://github.com/ashhart/TensorFold/releases/download/v1.2.7/tensorfold-1.2.7-macos-arm64.tar.gz"
  sha256 "b8e4c5e42f844f3f25c1c8a75d5d3a05d90dbf660df2c148d3c6e4cc6de2be75"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on arch: :arm64
  depends_on macos: :ventura

  # JPEG input needs exactly libjpeg-turbo 3.1.4.1, since decoders can differ in their pixels between releases.
  # The server loads it from lib/ beside its binary before the system path, so it is built into the keg.
  resource "libjpeg-turbo" do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.4.1/libjpeg-turbo-3.1.4.1.tar.gz"
    sha256 "ecae8008e2cc9ade2f2c1bb9d5e6d4fb73e7c433866a056bd82980741571a022"
  end

  def install
    libexec.install Dir["*"]
    resource("libjpeg-turbo").stage do
      jpeg = Pathname.pwd/"prefix"
      system "cmake", "-S", ".", "-B", "build", "-DENABLE_STATIC=OFF", "-DWITH_JAVA=OFF",
             *std_cmake_args(install_prefix: jpeg)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      (libexec/"lib").install Dir[jpeg/"lib/libturbojpeg.0*.dylib"]
    end
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
    assert_path_exists libexec/"lib/libturbojpeg.0.dylib"
    refute_match "is not libjpeg-turbo", shell_output("#{bin}/tensorfold-native capabilities --json 2>&1")
  end
end
