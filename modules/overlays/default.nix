inputs: [
  inputs.llm-agents.overlays.shared-nixpkgs
  # add more overlays here as you pick up new flake inputs or write your own, e.g.:
  # inputs.some-other-flake.overlays.default
  # (final: prev: { myPkg = prev.myPkg.overrideAttrs (_: { ... }); })
]
