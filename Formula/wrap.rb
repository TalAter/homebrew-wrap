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
      url "https://github.com/talater/wrap/releases/download/v0.0.2/wrap-aarch64-apple-darwin.tar.gz"
      sha256 "dcde1c175032fdb5baa7ca8d276871865e449e8cd173166370b6bdf35fbc0b8b"
    end
    on_intel do
      url "https://github.com/talater/wrap/releases/download/v0.0.1/wrap-x86_64-apple-darwin.tar.gz"
      sha256 "2efda4f408266b93017349dd597dd4dbd8ea6d0cad22e5fab9e37b42acb43f10"
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
