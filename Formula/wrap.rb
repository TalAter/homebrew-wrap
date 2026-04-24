class Wrap < Formula
  desc "Translate natural language into shell commands"
  homepage "https://github.com/talater/wrap"
  version "0.0.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/talater/wrap/releases/download/v#{version}/wrap-aarch64-apple-darwin.tar.gz"
      sha256 "b6a4f9cbcdfefb753c0e113f567835e88a1ff14da674770216b94b49d306601d"
    end
    on_intel do
      url "https://github.com/talater/wrap/releases/download/v#{version}/wrap-x86_64-apple-darwin.tar.gz"
      sha256 "fc58079c2df7d37c810b2e5673a9108c3055dfa5e01a1bffb62ededa1d6f79d6"
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
