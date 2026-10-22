class AgentPager < Formula
  desc "Durable local messaging between agent implementations"
  homepage "https://github.com/haywoodmarx/agent-pager"
  url "https://registry.npmjs.org/@haywoodmarx/agent-pager/-/agent-pager-0.2.1.tgz"
  sha256 "0b6f8bd2b2779aad36266cdcc4bd88be1da2962c68164e2f3019d93ed1534643"
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
