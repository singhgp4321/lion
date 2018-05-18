# Models 3 blocks with 2 gaps between them

[Mesh]
  type = FileMesh
  file = 'test_2_gaps.e'
  dim = 2
[]

[Variables]
  [./temp]
    block = '6 8 10'
    initial_condition = 0.5
  [../]
[]

[Kernels]
  [./hc]
    type = HeatConduction
    variable = temp
    block = '6 8 10'
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = temp
    boundary = 1
    value = 0.25
  [../]

  [./right]
    type = DirichletBC
    variable = temp
    boundary = 6
    value = 1
  [../]
[]

[ThermalContact]
  [./gap_conductivity]
    type = GapHeatTransfer
    variable = temp
    master = 3
    slave = 2
    gap_conductivity = 2.0
  [../]

  [./gap_conductivity2]
    type = GapHeatTransfer
    variable = temp
    master = 5
    slave = 4
    gap_conductivity = 2.0
  [../]
[]

[Materials]
  [./hcm]
    type = HeatConductionMaterial
    block = '6 7 8 9 10'
    temp = temp
    thermal_conductivity = 1
  [../]
[]

[Problem]
  type = FEProblem
  kernel_coverage_check = false
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Steady
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  [./out]
    type = Exodus
  [../]
[]
