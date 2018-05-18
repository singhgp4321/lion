[Mesh]
  file = pellet_v3_20180419.e
[]

[Variables]
  [./electric_potential]
    order = FIRST
    family = LAGRANGE
  [../]

  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 273.15
  [../]
[]

[AuxVariables]
  [./current_x]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./current_y]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./current_x]
    type = CurrentAux
    variable = current_x
    component = x
    execute_on = timestep_end
    potential_variable = electric_potential
  [../]
  [./current_y]
    type = CurrentAux
    variable = current_y
    component = y
    execute_on = timestep_end
    potential_variable = electric_potential
  [../]
[]

[Kernels]
  [./current]
    type = ElectricPotential
    variable = electric_potential
  [../]

  [./heat]
    type = HeatConduction
    variable = temp
  [../]

  [./heat_time_derivative]
    type = HeatConductionTimeDerivative
    variable = temp
  [../]

  [./heat_generation]
    type = JouleHeatingSource
    variable = temp
    elec = electric_potential
    block = 'Graphite'
  [../]
[]

[ThermalContact]
  [./gap]
    type = GapHeatTransfer
    master = Graphite_inner
    slave = SiC_outer
    gap_conductivity = 0.001
    variable = temp
  [../]
[]

[BCs]
  [./bottom_potential]
    type = DirichletBC
    variable = electric_potential
    boundary = 'SiC_bottom Graphite_bottom'
    value = 10
  [../]

  [./top_potential]
    type = DirichletBC
    variable = electric_potential
    boundary = 'SiC_top Graphite_top'
    value = 0
  [../]

  [./top_temp]
    type = DirichletBC
    variable = temp
    boundary = 'SiC_top Graphite_top'
    value = 300
  [../]

  [./bottom_temp]
    type = DirichletBC
    variable = temp
    boundary = 'SiC_bottom Graphite_bottom'
    value = 400
  [../]
[]

[Materials]
  [./Silicon_Carbide]
    type = SiC
    block = 'SiC'
  [../]
  [./Graphite]
    type = Graphite
    block = 'Graphite'
  [../]
[]

[Problem]
  type = FEProblem
  coord_type = RZ
  rz_coord_axis = Y
[]

[Preconditioning]
  active = 'SMP_newton'
  [./SMP_jfnk_full]
      type = SMP
      full = true
      solve_type = 'PJFNK'
      petsc_options_iname = '-pc_type'
      petsc_options_value = 'lu'
  [../]

  [./SMP_jfnk]
      type = SMP
      off_diag_row = electric_potential
      off_diag_column = temp
      solve_type = 'PJFNK'
      #petsc_options_iname = '-pc_type -pc_hypre_type'
      #petsc_options_value = 'hypre boomeramg'

      petsc_options_iname = '-pc_type'
      petsc_options_value = 'lu'
  [../]

  [./SMP_newton]
      type = SMP
      #off_diag_row = electric_potential
      #off_diag_column = temp
      full = true
      solve_type = 'NEWTON'
      petsc_options_iname = '-pc_type'
      petsc_options_value = 'lu'
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 100
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
