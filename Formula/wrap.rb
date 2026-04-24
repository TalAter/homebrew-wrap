class Wrap < Formula
  desc "Translate natural language into shell commands"
  homepage "https://github.com/talater/wrap"
  # Class-level url is a syntax-validation placeholder — brew readall on Linux
  # rejects formulae with no visible url. `depends_on :macos` blocks install
  # there, and the `on_macos` block overrides this url on the supported path.
  url "https://github.com/talater/wrap/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "92bf02bbd5050461839ea5a11d7b3c83e7cc457679817ac12eba7594ad78b26d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/talater/wrap/releases/download/v0.0.2/wrap-aarch64-apple-darwin.tar.gz"
      sha256 "dcde1c175032fdb5baa7ca8d276871865e449e8cd173166370b6bdf35fbc0b8b"
    end
    on_intel do
      url "https://github.com/talater/wrap/releases/download/v0.0.2/wrap-x86_64-apple-darwin.tar.gz"
      sha256 "907dde687d68b359051f38af027574a15afd2198bb97546a3e227c9fd9764b4b"
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
