class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v9.10.tar.gz"
  sha256 "a04eb7b0bdc314ba7cefd5ed1f8529ecc1b18ef524e8f7446e1a2cbf76fdcc4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a1cd348acd1d85b532456383240e9369178a514cb245d6afbc3845f2f4cbf9c" => :catalina
    sha256 "ea1179e52f2e6ff8ba5ce43cff8e8e4bdc3d050950e3745c82ebaa8ef56ed5ba" => :mojave
    sha256 "b74e16e919cfc93bbabfa5d6b9590f84b887888eefc57f077c622f55243d7d14" => :high_sierra
    sha256 "7e4e07701cd206f2d88e63a6b88f0e1c299589e9f2737b67ec15e64e557b78e9" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test-gb-asm.s").write <<~EOS
      .MEMORYMAP
       DEFAULTSLOT 1.01
       SLOT 0.001 $0000 $2000
       SLOT 1.2 STArT $2000 sIzE $6000
       .ENDME

       .ROMBANKMAP
       BANKSTOTAL 2
       BANKSIZE $2000
       BANKS 1
       BANKSIZE $6000
       BANKS 1
       .ENDRO

       .BANK 1 SLOT 1

       .ORGA $2000


       ld hl, sp+127
       ld hl, sp-128
       add sp, -128
       add sp, 127
       adc 200
       jr -128
       jr 127
       jr nc, 127
    EOS
    system bin/"wla-gb", "-o", testpath/"test-gb-asm.s"
  end
end
