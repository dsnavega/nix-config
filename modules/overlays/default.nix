inputs: [
  inputs.llm-agents.overlays.shared-nixpkgs
  (final: prev: { numtide = prev.llm-agents; })
  # add more overlays here as you pick up new flake inputs or write your own, e.g.:
  # inputs.some-other-flake.overlays.default
  # (final: prev: { myPkg = prev.myPkg.overrideAttrs (_: { ... }); })
]
