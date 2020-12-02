{
  nixpkgs = fetchTarball {
    name = "nixos-unstable-2020.11.16";
    url = "https://github.com/nixos/nixpkgs/archive/4f3475b113c9.tar.gz";
    sha256 = "158iik656ds6i6pc672w54cnph4d44d0a218dkq6npzrbhd3vvbg";
  };
  nixt = fetchTarball {
    name = "nix-unstable-2020.06.10";
    url = "https://github.com/nix-community/nixt/archive/6338fcdbaf34.tar.gz";
    sha256 = "00fg9862yz35g2jx19llz1sgmpxgb8ip99ba9f8cbxpdfhp3nfj8";
  };
}
