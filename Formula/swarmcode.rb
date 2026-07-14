class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.9.2"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.9.2/swarmcode-v0.9.2-darwin-universal.tar.gz"
  sha256 "cce600e1a7b9eced6b9eb40d013ba2b11a6e2f229a714f3865714de225e3bd4b"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
