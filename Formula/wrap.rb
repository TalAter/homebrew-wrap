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
      url "https://github.com/talater/wrap/releases/download/v0.0.5/wrap-aarch64-apple-darwin.tar.gz"
      sha256 "ecd525f76dea720d713fc972e43ae23cb053b415f47045fa1449915db000bf9b"
    end
    on_intel do
      url "https://github.com/talater/wrap/releases/download/v0.0.5/wrap-x86_64-apple-darwin.tar.gz"
      sha256 "7e7b004576a5517e9f280f3b062e9d5cfc220b9949b731f8ea15162bee3888d2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/talater/wrap/releases/download/v0.0.5/wrap-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "084241c9cec88abf58143ff0109efdacf6d5d1fb92c8472cbd623fa8917f5929"
    end
    on_intel do
      url "https://github.com/talater/wrap/releases/download/v0.0.5/wrap-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a0df867af92c1933886d55524b0f571ef7f50a19d5ab3fc5fd3e877c33b572cf"
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
