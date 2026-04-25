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
      url "https://github.com/talater/wrap/releases/download/v0.0.3/wrap-aarch64-apple-darwin.tar.gz"
      sha256 "f96b0a450055578dda59e312863daa4ba83d83e2726fb8c5f10083caac01328c"
    end
    on_intel do
      url "https://github.com/talater/wrap/releases/download/v0.0.3/wrap-x86_64-apple-darwin.tar.gz"
      sha256 "9d365d2152e71427467640cd02954cfae4b863ec4faefd26b80c54d2f6f1eecd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/talater/wrap/releases/download/v0.0.3/wrap-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bad28a4bbefb6648fed9f666d1777bf813f3b252b98d5e78d0975bed8c716932"
    end
    on_intel do
      url "https://github.com/talater/wrap/releases/download/v0.0.3/wrap-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cf777533e34257ce7b2ae767cfe24e6959628c22920ca5b16a65e1065c6d260d"
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
