class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.10.1"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.10.1/swarmcode-v0.10.1-darwin-universal.tar.gz"
  sha256 "2a1127ac82edfcb28f5901a3c98ac73b0030cb1a743caef7c6fcc3971ce0d87b"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
