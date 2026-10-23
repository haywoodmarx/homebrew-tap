class AgentPager < Formula
  desc "Durable local messaging between agent implementations"
  homepage "https://github.com/haywoodmarx/agent-pager"
  url "https://registry.npmjs.org/@haywoodmarx/agent-pager/-/agent-pager-0.4.0.tgz"
  sha256 "6857ee126dedfc055a10706f2112a18a072378c90dd1ecf0d23b406347638744"
  license "MIT"

  depends_on "bun"
  depends_on :macos

  preserve_rpath

  def install
    libexec.install Dir["*"]
    cd libexec do
      system formula_opt_bin("bun")/"bun", "install", "--production", "--omit=peer", "--ignore-scripts"
    end
    (bin/"pager").write <<~SH
      #!/bin/bash
      export PAGER_BUN_PATH="${PAGER_BUN_PATH:-#{formula_opt_bin("bun")}/bun}"
      export PAGER_PACKAGE_ROOT="#{opt_libexec}"
      exec "$PAGER_BUN_PATH" "#{opt_libexec}/dist/src/launch/cli.js" "$@"
    SH
  end

  test do
    assert_match '"ok":true', shell_output("#{bin}/pager status")
  end
end
