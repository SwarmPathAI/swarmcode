class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.10.0"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.10.0/swarmcode-v0.10.0-darwin-universal.tar.gz"
  sha256 "99c81705dbcf7423a61a97eb1e1de466e3d673f0ef9501482026e849c822932b"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
