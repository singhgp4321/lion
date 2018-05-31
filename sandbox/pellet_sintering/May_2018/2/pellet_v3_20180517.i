[Problem]
  type = FEProblem
  coord_type = RZ
  rz_coord_axis = Y
[]

[Mesh]
  file = pellet_v4_20180517.e
[]

[Functions]

  [./ramp]
    type = PiecewiseLinear
    x = '0   1   2'
    y = '100 200 200'
  [../]
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
    block = 'pellet die upper_punch lower_punch'
  [../]
[]

[ThermalContact]
  [./pellet_die_gap]
    type = GapHeatTransfer
    master = die_inner
    slave = pellet_outer
    gap_conductivity = 0.001
    variable = temp
  [../]
  [./lower_punch_die_gap]
    type = GapHeatTransfer
    master = die_inner
    slave = lower_punch_outer
    gap_conductivity = 0.001
    variable = temp
  [../]
  [./upper_punch_die_gap]
    type = GapHeatTransfer
    master = die_inner
    slave = upper_punch_outer
    gap_conductivity = 0.001
    variable = temp
  [../]
  [./upper_punch_pellet_gap]
    type = GapHeatTransfer
    master = upper_punch_bottom
    slave = pellet_top
    gap_conductivity = 0.001
    variable = temp
    gap_geometry_type = PLATE
  [../]
  [./lower_punch_pellet_gap]
    type = GapHeatTransfer
    master = lower_punch_top
    slave = pellet_bottom
    gap_conductivity = 0.001
    variable = temp
    gap_geometry_type = PLATE
  [../]

# The following contacts are for electric_potential

  [./pellet_die_gap_current]
    type = GapHeatTransfer
    master = die_inner
    slave = pellet_outer
    gap_conductivity = 0.001
    variable = electric_potential
    appended_property_name = 2
  [../]
  [./lower_punch_die_gap_current]
    type = GapHeatTransfer
    master = die_inner
    slave = lower_punch_outer
    gap_conductivity = 0.001
    variable = electric_potential
    appended_property_name = 2
  [../]
  [./upper_punch_die_gap_current]
    type = GapHeatTransfer
    master = die_inner
    slave = upper_punch_outer
    gap_conductivity = 0.001
    variable = electric_potential
    appended_property_name = 2
  [../]
  [./upper_punch_pellet_gap_current]
    type = GapHeatTransfer
    master = upper_punch_bottom
    slave = pellet_top
    gap_conductivity = 0.001
    variable = electric_potential
    appended_property_name = 2
    gap_geometry_type = PLATE
  [../]
  [./lower_punch_pellet_gap_current]
    type = GapHeatTransfer
    master = lower_punch_top
    slave = pellet_bottom
    gap_conductivity = 0.001
    variable = electric_potential
    appended_property_name = 2
    gap_geometry_type = PLATE
  [../]
[]

[BCs]
  # The following bc are for electric_potential

  [./top_potential_upper_punch]
    type = DirichletBC
    variable = electric_potential
    boundary = 'upper_punch_top'
    value = 4
  [../]

  [./bottom_potential_upper_punch]
    type = DirichletBC
    variable = electric_potential
    boundary = 'upper_punch_bottom'
    value = 2.05
  [../]

  [./bottom_potential_pellet]
    type = DirichletBC
    variable = electric_potential
    boundary = 'pellet_top'
    value = 2.05
  [../]

  [./top_potential_pellet]
    type = DirichletBC
    variable = electric_potential
    boundary = 'pellet_bottom'
    value = 1.95
  [../]

  [./top_potential_lower_punch]
    type = DirichletBC
    variable = electric_potential
    boundary = 'lower_punch_top'
    value = 1.95
  [../]

  [./bottom_potential_lower_punch]
    type = DirichletBC
    variable = electric_potential
    boundary = 'lower_punch_bottom'
    value = 0
  [../]
  [./top_potential_die]
    type = DirichletBC
    variable = electric_potential
    boundary = 'die_top'
    value = 3.5
  [../]

  [./bottom_potential_die]
    type = DirichletBC
    variable = electric_potential
    boundary = 'die_bottom'
    value = 0.5
  [../]

  # The following bc are for temperature

  [./upper_punch_top_temp]
    type = DirichletBC
    variable = temp
    boundary = 'upper_punch_top'
    value = 700
  [../]

  [./lower_punch_bottom_temp]
    type = DirichletBC
    variable = temp
    boundary = 'lower_punch_bottom'
    value = 700
  [../]

  [./die_top_temp]
    type = DirichletBC
    variable = temp
    boundary = 'die_top'
    value = 1000
  [../]

  [./die_bottom_temp]
    type = DirichletBC
    variable = temp
    boundary = 'die_bottom'
    value = 1000
  [../]
[]

[Materials]
  [./Pellet]
    type = SiC
    block = 'pellet'
  [../]
  [./Die]
    type = Graphite
    block = 'die'
  [../]
  [./Lower_punch]
    type = Graphite
    block = 'lower_punch'
  [../]
  [./Upper_punch]
    type = Graphite
    block = 'upper_punch'
  [../]
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

  nl_abs_tol = 1e-3
  nl_rel_tol = 1e-8
  nl_max_its = 30

  l_tol = 1e-6
  l_max_its = 100

  start_time = 0.0
  end_time = 1200.0
  num_steps = 500

  dtmax = 10.0
  dtmin = 1.0

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    optimal_iterations = 12
    iteration_window = 1
    linear_iteration_ratio = 100
  [../]
[]



[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
