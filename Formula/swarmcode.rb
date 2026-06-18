class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.5.2"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.5.2/swarmcode-v0.5.2-darwin-universal.tar.gz"
  sha256 "865e073fba1acc89d0aaa6c0d23cc5d27debb20aa572f0f96591f76b1cb7559b"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
