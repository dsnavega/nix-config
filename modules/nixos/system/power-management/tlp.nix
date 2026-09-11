{ ... }:
{
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";
      PCIE_ASPM_ON_BAT = "powersupersave";
      RUNTIME_PM_ON_BAT = "auto";
      CPU_MAX_PERF_ON_AC = 50;
      CPU_MAX_PERF_ON_BAT = 50;
      CPU_BOOST_ON_AC = 0;
      CPU_BOOST_ON_BAT = 0;
    };
  };
}
