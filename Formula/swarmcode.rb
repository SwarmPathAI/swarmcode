class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.5.5"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.5.5/swarmcode-v0.5.5-darwin-universal.tar.gz"
  sha256 "3ddbb523401c22c70c704edcb91200a371a1001da225a28931ce5d2677c80f4c"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
