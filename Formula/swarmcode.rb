class Swarmcode < Formula
  desc "Provider-agnostic AI coding agent for your terminal"
  homepage "https://github.com/SwarmPathAI/swarmcode"
  version "0.5.3"
  url "https://github.com/SwarmPathAI/swarmcode/releases/download/v0.5.3/swarmcode-v0.5.3-darwin-universal.tar.gz"
  sha256 "3e013a104b996f1d156ce08cabe00515792f9da7d9399cd4146ef845a0363b63"

  def install
    bin.install "swarmcode"
  end

  test do
    assert_match "swarmcode", shell_output("#{bin}/swarmcode --version")
  end
end
