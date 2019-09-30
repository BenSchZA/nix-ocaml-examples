# paramaterised derivation with dependencies injected (callPackage style)
{ pkgs, stdenv, opam2nix }:
stdenv.mkDerivation {
	name = "opium-example";
	src = ../.;
	buildInputs = opam2nix.build {
		specs = opam2nix.toSpecs [ "dune" "ocamlbuild" "ocamlfind" "opium" ];
		# ocamlAttr = "ocaml_4_03";
	};
	buildPhase = ''
		dune build main.exe
	'';
	installPhase = ''
		mkdir $out/bin
		cp --dereference _build/default/main.exe $out/bin/${name}
	'';
}
