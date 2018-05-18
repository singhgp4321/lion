[Mesh]
  file = pellet_v3_20180419.e
[]

[Variables]
  [./diffused]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = diffused
  [../]
[]

[BCs]
  [./bottom]
    type = DirichletBC
    variable = diffused
    boundary = 'SiC_bottom Graphite_bottom'
    value = 1
  [../]

  [./top]
    type = DirichletBC
    variable = diffused
    boundary = 'SiC_top Graphite_top'
    value = 0
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
