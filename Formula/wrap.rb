class Wrap < Formula
  desc "Translate natural language into shell commands"
  homepage "https://github.com/talater/wrap"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/talater/wrap/releases/download/v0.0.4/wrap-aarch64-apple-darwin.tar.gz"
      sha256 "addb0274dbe0e3c398f2534a5d9fdcf06ed0d5ddc9dc45c30313faa500e05a9d"
    end
    on_intel do
      url "https://github.com/talater/wrap/releases/download/v0.0.4/wrap-x86_64-apple-darwin.tar.gz"
      sha256 "1c4256e7596f7d6f62a5f49d22c6c559f9862e3fe36f51036d10560e9ff3e736"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/talater/wrap/releases/download/v0.0.4/wrap-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fc9673e49516d4f744b03c0e0136cc489dd80b4c17e3fc0c5b8733c8cb0191d3"
    end
    on_intel do
      url "https://github.com/talater/wrap/releases/download/v0.0.4/wrap-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e2bfae13ba32114ba926fe2010a0dd84130e7d8ff2a2451669a6f1721279d828"
    end
  end

  deny_network_access! :test

  def install
    bin.install "wrap"
    generate_completions_from_executable(
      bin/"wrap", "--completion",
      shells: [:bash, :zsh, :fish]
    )
  end

  def caveats
    <<~EOS
      Run `wrap` to configure your LLM provider.

      Tip: add `alias w=wrap` to your shell rc for a shorter command.
    EOS
  end

  test do
    ENV["WRAP_HOME"] = testpath/".wrap"
    assert_match version.to_s, shell_output("#{bin}/wrap --version")
    assert_match "#compdef wrap", shell_output("#{bin}/wrap --completion zsh")
    assert_match "_wrap", shell_output("#{bin}/wrap --completion bash")
    assert_match "complete -c wrap", shell_output("#{bin}/wrap --completion fish")
  end
end
