[Problem]
  type = FEProblem
  coord_type = RZ
  rz_coord_axis = Y
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  file = pellet_v5_20180529.e
[]

[Functions]

  [./temp-time_punch]
    type = PiecewiseLinear
    data_file = temp-vs-time_punch_v2.csv
  [../]

  [./temp-time_die-top]
    type = PiecewiseLinear
    data_file = temp-vs-time_die-top_y65mm.csv
  [../]

  [./temp-time_die-outer]
    type = PiecewiseLinear
    data_file = temp-vs-time_die-outer.csv
  [../]

  [./interpolate_die_outer_temp]
    type = InterpolateFunction3pt
    functions = 'temp-time_punch temp-time_die-outer temp-time_punch'
    w = '0.005 0.035 0.065'
  [../]

  [./interpolate_upper_punch_outer_temp]
    type = InterpolateFunction
    functions = 'temp-time_die-top temp-time_punch'
    w = '0.07 0.088'
  [../]

  [./interpolate_lower_punch_outer_temp]
    type = InterpolateFunction
    functions = 'temp-time_punch temp-time_die-top'
    w = '-0.018 0.0'
  [../]

[]

[Modules]
  [./TensorMechanics]
    [./Master]
      [./all]
        strain = SMALL
        incremental = true
        add_variables = true
        eigenstrain_names = eigenstrain
        generate_output = 'strain_xx strain_yy'
      [../]
    [../]
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
    slave = lower_punch_outer_contact
    gap_conductivity = 0.001
    variable = temp
  [../]
  [./upper_punch_die_gap]
    type = GapHeatTransfer
    master = die_inner
    slave = upper_punch_outer_contact
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
    slave = lower_punch_outer_contact
    gap_conductivity = 0.001
    variable = electric_potential
    appended_property_name = 2
  [../]
  [./upper_punch_die_gap_current]
    type = GapHeatTransfer
    master = die_inner
    slave = upper_punch_outer_contact
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
    value = 3.0
  [../]

  [./bottom_potential_die]
    type = DirichletBC
    variable = electric_potential
    boundary = 'die_bottom'
    value = 1.0
  [../]

  # The following bc are for temperature

  [./punch_temp_top_bottom]
    type = FunctionDirichletBC
    variable = temp
    boundary = 'upper_punch_top lower_punch_bottom'
    function = temp-time_punch
  [../]

  [./upper_punch_temp]
    type = FunctionDirichletBC
    variable = temp
    boundary = 'upper_punch_outer_no-contact'
    function = interpolate_upper_punch_outer_temp
  [../]

  [./lower_punch_temp]
    type = FunctionDirichletBC
    variable = temp
    boundary = 'lower_punch_outer_no-contact'
    function = interpolate_lower_punch_outer_temp
  [../]

  [./die_top_and_bottom_temp]
    type = FunctionDirichletBC
    variable = temp
    boundary = 'die_top die_bottom'
    function = temp-time_die-top
  [../]

  [./die_outer_temp]
    type = FunctionDirichletBC
    variable = temp
    boundary = 'die_outer'
    function = interpolate_die_outer_temp
  [../]

  [./horizontal_disp]
    type = DirichletBC
    variable = disp_x
    boundary = 'pellet_inner die_inner upper_punch_inner lower_punch_inner'
    value = 0.0
  [../]
  [./y_bot]
    type = DirichletBC
    variable = disp_y
    boundary = 'pellet_bottom die_bottom upper_punch_bottom lower_punch_bottom'
    value = 0.0
  [../]
[]

[Materials]
  [./Pellet]
    type = SiC
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

  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2.1e5
    poissons_ratio = 0.3
  [../]
  [./small_stress]
    type = ComputeFiniteStrainElasticStress
  [../]
  [./thermal_expansion_strain]
    type = ComputeThermalExpansionEigenstrain
    stress_free_temperature = 298
    thermal_expansion_coeff = 1.3e-5
    temperature = temp
    eigenstrain_name = eigenstrain
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
