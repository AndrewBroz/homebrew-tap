class Prosefix < Formula
  include Language::Python::Virtualenv

  desc "Clean, consistent prose in Markdown: spelling, style guide, typos, commas"
  homepage "https://github.com/AndrewBroz/prosefix"
  url "https://files.pythonhosted.org/packages/5c/e6/eade3f6f775ab80f1d6c2e2c58ce6ad76831e6ba0681ce9a7553716cd1ef/prosefix-0.2.0.tar.gz"
  sha256 "6fcab2484071c610297f3ca4a0fd0372301161e10dab29a5273eda690c1adefe"
  license "MIT"

  depends_on "languagetool"
  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "typos-cli"
  depends_on "vale"

  resource "adjudicate" do
    url "https://files.pythonhosted.org/packages/0e/93/0db9780fda80de710a76e27701084d530bc74215d53fce6b3e4fec5408d8/adjudicate-0.3.2.tar.gz"
    sha256 "75eccdfc691a9ed1a83b1783a34686f6f9024c07518de382afc93878271e2724"
  end

  resource "proofix" do
    url "https://files.pythonhosted.org/packages/dd/4a/a6ebbee07b84a871267a310d8e7f3a47ee001e1263deb669b396a2324bcc/proofix-0.7.0.tar.gz"
    sha256 "ca3a63dcab05736d84e0f71f58521b8a17b7028122c94309a9b8a0a7227012ff"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  # spylls' sdist builds with the legacy `poetry>=0.12` backend, which cannot be
  # built from source here (it pulls in Rust-based build dependencies), so use
  # the pure-Python wheel.
  resource "spylls" do
    url "https://files.pythonhosted.org/packages/cd/19/ce6fcb4b86e188983bcfc1f84e4ac6f3038ca8d68b6d70a678cdc566f66c/spylls-0.1.7-py2.py3-none-any.whl"
    sha256 "0c7fa4b66615f390bd12fd37939b85934c012309fd3cce8584844c54270b7776"
  end

  resource "stylefix" do
    url "https://files.pythonhosted.org/packages/ff/97/58b216b4bd921af05bfc0dc197858c7796d5cc256538b8fd32d3b839f0d2/stylefix-0.8.1.tar.gz"
    sha256 "31650bc9490e6f8156ccd868a95c2862e531a7d0567ee23dd2c78e608fc720bf"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/stylefix", libexec/"bin/proofix"
    man1.install buildpath/"man/prosefix.1"
    resource("stylefix").stage { man1.install "man/stylefix.1" }
    resource("proofix").stage { man1.install "man/proofix.1" }
  end

  test do
    (testpath/"n.md").write "The color of the program is \"important\" -- really.\n"
    system bin/"prosefix", "--version"
    system bin/"prosefix", testpath/"n.md", "--llm", "none", "-q"
    assert_match "—", (testpath/"n.md").read
  end
end
