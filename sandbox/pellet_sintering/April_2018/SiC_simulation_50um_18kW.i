
[GlobalParams]
  # Set initial fuel density, other global parameters
  density = 10431.0
  disp_x = disp_x
  disp_y = disp_y
  order = SECOND
  family = LAGRANGE
  energy_per_fission = 3.2e-11  # J/fission
[]

[Problem]
  # Specify coordinate system type
  coord_type = RZ
[]

[Mesh]
  # Import mesh file
#file = clad4m572um_82um_quad8.e
  type = SmearedPelletMesh
  clad_mesh_density = customize
  pellet_mesh_density = customize
  pellet_quantity = 1

  pellet_outer_radius = 4128.0e-6 # -----------------------------------------------------------------------------------EDIT
  clad_gap_width =        50.0e-6 # -----------------------------------------------------------------------------------EDIT
  clad_thickness =       572.0e-6 # -----------------------------------------------------------------------------------EDIT

  pellet_height = 3.6576
clad_top_gap_height = 0.2317 # ----------------------------------------------------------------------------------------EDIT
  clad_bot_gap_height = 0.1051

  ny_p = 300 # pellet axial # -----------------------------------------------------------------------------------------EDIT
  nx_p = 11  # pellet radial

  nx_c = 5   # cladding radial
  ny_c = 900 # cladding wall # ----------------------------------------------------------------------------------------EDIT
  ny_cu = 3  # cladding upper
  ny_cl = 3  # cladding lower

  elem_type = QUAD8
  displacements = 'disp_x disp_y'
  patch_size = 10 # For contact algorithm
  patch_update_strategy = auto
  partitioner = centroid
  centroid_partitioner_direction = y
[]

[Variables]
  # Define dependent variables and initial conditions

  [./disp_x]
  [../]

  [./disp_y]
  [../]

  [./temp]
    initial_condition = 273.15     # set initial temp to STP (this allows for correct thermal expansion, as most measurements are made at room temp)
  [../]
[]

[AuxVariables]
  # Define auxilary variables

  [./vstrain] #----------------------------------------------------------------------------------------------------EDIT
   block = '1'
   order = CONSTANT
   family = MONOMIAL
  [../]

  [./Thermal_Strain] #--------------------------------------------------------------------------------------------EDIT
   block = '1'
   order = CONSTANT
   family = MONOMIAL
  [../]

  [./Thermal_Conductivity]
   block = '1'
   order = CONSTANT
   family = MONOMIAL
  [../]

  [./Specific_Heat_Capacity]
   block = '1'
   order = CONSTANT
   family = MONOMIAL
  [../]

  [./creep_xx]
    block = '1'
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./creep_yy]
    block = '1'
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./creep_zz]
    block = '1'
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./fast_neutron_flux]
    block = '1'
  [../]

  [./fast_neutron_fluence]
    block = '1'
  [../]
  [./grain_radius]
    block = '3'
    initial_condition = 10e-6
  [../]

  [./stress_xx]      # stress aux variables are defined for output; this is a way to get integration point variables to the output file
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz_gyan]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./vonmises]
    order = CONSTANT
    family = MONOMIAL
  [../]
#  [./creep_strain_mag]
#    order = CONSTANT
#    family = MONOMIAL
#  [../]

  [./hoop_stress]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./radial_stress]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./axial_stress]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./gap_cond]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./coolant_htc]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  # Define functions to control power and boundary conditions

  [./power_history]
    type = PiecewiseLinear
    x = '0 1e4 1e8'
    y = '0 18 18'     # -----------------------------------------------------------------------------------EDIT (power in kW/m)
    #data_file = powerhistory.csv
    scale_factor = 1e3
  [../]

  [./axial_peaking_factors]      # reads and interpolates an input file containing the axial power profile vs time
    type = PiecewiseBilinear
    data_file = FullRod_PP.csv
    scale_factor = 1
    axis = 1 # (0,1,2) => (x,y,z)
  [../]

  [./pressure_ramp]              # reads and interpolates input data defining amplitude curve for fill gas pressure
    type = PiecewiseLinear
    x = '-200 0'
    y = '0 1'
  [../]

  [./q]
    type = CompositeFunction
    functions = 'power_history axial_peaking_factors'
  [../]
[]

[SolidMechanics]
  # Specify that we need solid mechanics (divergence of stress)
  [./solid]
    disp_r = disp_x
    disp_z = disp_y
    temp = temp
  [../]
[]

[Kernels]
  # Define kernels for the various terms in the PDE system

  [./gravity]       # body force term in stress equilibrium equation
    type = Gravity
    variable = disp_y
    value = -9.81
  [../]

  [./heat]         # gradient term in heat conduction equation
    type = HeatConduction
    variable = temp
  [../]

  [./heat_ie]       # time term in heat conduction equation
    type = HeatConductionTimeDerivative
    variable = temp
  [../]

  [./heat_source]  # source term in heat conduction equation
     type = NeutronHeatSource
     variable = temp
     block = '3'     # fission rate applied to the fuel (block 2) only
#     fission_rate = fission_rate  # coupling to the fission_rate aux variable
     burnup_function = burnup
  [../]
[]

[Burnup]
  [./burnup]
    block = '3'
    rod_ave_lin_pow = power_history          # using the power function defined above
    axial_power_profile = axial_peaking_factors     # using the axial power profile function defined above
    num_radial = 20
    num_axial = 300
    a_lower = 0.10734   # mesh dependent
    a_upper = 3.76494   # mesh dependent
    fuel_inner_radius = 0
    fuel_outer_radius = .004128
    fuel_volume_ratio = 1.0 # for use with dished pellets (ratio of actual volume to cylinder volume)
    order = CONSTANT
    family = MONOMIAL

    #N235 = N235 # Activate to write N235 concentration to output file
    #N238 = N238 # Activate to write N238 concentration to output file
    #N239 = N239 # Activate to write N239 concentration to output file
    #N240 = N240 # Activate to write N240 concentration to output file
    #N241 = N241 # Activate to write N241 concentration to output file
    #N242 = N242 # Activate to write N242 concentration to output file
    RPF = RPF
  [../]
[]

[AuxKernels]
  # Define auxilliary kernels for each of the aux variables
#  [./swelling]
#    type = SwellingAux
#    variable = swelling
#    fast_neutron_fluence = fast_neutron_fluence
#    temperature = temp
#    block = '1'
#    execute_on = timestep_begin
#  [../]


  [./SwellingVariableOutputAux] #----------------------------------------------------------------------------------------------------EDIT
    type = MaterialRealAux
    property = volumetric_irradiation_strain
    variable = vstrain
    block = '1'
    execute_on = timestep_end
  [../]

  [./thermal_strain_output_aux] #----------------------------------------------------------------------------------------------------EDIT
    type = MaterialRealAux
    property = thermal_strain
    variable = Thermal_Strain
    block = '1'
    execute_on = timestep_end
  [../]

  [./ThermalConductivityVariableOutputAux]
    type = MaterialRealAux
    property = thermal_conductivity
    variable = Thermal_Conductivity
    block = '1'
    execute_on = timestep_end
  [../]

  [./SpecificHeatCapacityVariableOutputAux]
    type = MaterialRealAux
    property = specific_heat
    variable = Specific_Heat_Capacity
    block = '1'
    execute_on = timestep_end
  [../]

  [./creep_xx]
    type = MaterialTensorAux
    tensor = creep_strain
    variable = creep_xx
    index = 0
    execute_on = timestep_end
  [../]

  [./creep_yy]
    type = MaterialTensorAux
    tensor = creep_strain
    variable = creep_yy
    index = 1
    execute_on = timestep_end
  [../]

  [./creep_zz]
    type = MaterialTensorAux
    tensor = creep_strain
    variable = creep_zz
    index = 2
    execute_on = timestep_end
  [../]

  [./fast_neutron_flux]
    type = FastNeutronFluxAux
    variable = fast_neutron_flux
    block = '1'
    rod_ave_lin_pow = power_history
    axial_power_profile = axial_peaking_factors
    factor = 4.4e13
    execute_on = timestep_end
  [../]

  [./fast_neutron_fluence]
    type = FastNeutronFluenceAux
    variable = fast_neutron_fluence
    block = '1'
    fast_neutron_flux = fast_neutron_flux
    execute_on = timestep_begin
  [../]

  [./grain_radius]
    type = GrainRadiusAux
    block = '3'
    variable = grain_radius
    temp = temp
    execute_on = linear
  [../]

  [./stress_xx]               # computes stress components for output
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xx
    index = 0
    execute_on = timestep_end # for efficiency, only compute at the end of a timestep
  [../]
  [./stress_yy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yy
    index = 1
    execute_on = timestep_end
  [../]
  [./stress_zz]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_zz_gyan
    index = 2
    execute_on = timestep_end
  [../]
  [./vonmises]
    type = MaterialTensorAux
    tensor = stress
    variable = vonmises
    quantity = vonmises
    execute_on = timestep_end
  [../]
#  [./creep_strain_mag]
#    type = MaterialTensorAux
#    block = ''1' '3''
#    tensor = creep_strain
#    variable = creep_strain_mag
#    quantity = plasticstrainmag
#    execute_on = timestep_end
#  [../]

  [./hoop_stress]
    type = MaterialTensorAux
    tensor = stress
    variable = hoop_stress
    quantity = hoop
    point1 = '0, 0, 0'
    point2 = '0, 1, 0'
    execute_on = timestep_end
  [../]
  [./radial_stress]
    type = MaterialTensorAux
    tensor = stress
    variable = radial_stress
    quantity = radial
    point1 = '0, 0, 0'
    point2 = '0, 1, 0'
    execute_on = timestep_end
  [../]
  [./axial_stress]
    type = MaterialTensorAux
    tensor = stress
    variable = axial_stress
    quantity = axial
    point1 = '0, 0, 0'
    point2 = '0, 1, 0'
    execute_on = timestep_end
  [../]

  [./conductance]
    type = MaterialRealAux
    property = gap_conductance
    variable = gap_cond
    boundary = '10'
  [../]
  [./coolant_htc]
    type = MaterialRealAux
    property = coolant_channel_htc
    variable = coolant_htc
    boundary = '1 2 3'
  [../]
[]

[Contact]
  # Define mechanical contact between the fuel (sideset=10) and the clad (sideset=5)
  [./pellet_clad_mechanical]
    master = 5
    slave = 10

system = Constraint                    #########################
formulation = penalty
penalty = 0.9e14
model = frictionless
normal_smoothing_distance = 0.1
normalize_penalty = true

    disp_x = disp_x
    disp_y = disp_y
#    penalty = 1e7
  [../]
[]

[ThermalContact]
  # Define thermal contact between the fuel (sideset=10) and the clad (sideset=5)
  [./thermal_contact]
    type = GapHeatTransferLWR
    variable = temp
    master = 5
    slave = 10
    initial_moles = initial_moles       # coupling to a postprocessor which supplies the initial plenum/gap gas mass
    gas_released = fis_gas_released     # coupling to a postprocessor which supplies the fission gas addition
    quadrature = true
    plenum_pressure = plenum_pressure
    contact_pressure = contact_pressure
    jump_distance_model = KENNARD             ##############################
    normal_smoothing_distance = 0.1
  [../]


 # [./thermal_contact_bottom]
  #  type = GapHeatTransferLWR
   # variable = temp
   # master = 22
   # slave = 21
   # coord_type = XYZ
   # initial_moles = initial_moles       # coupling to a postprocessor which supplies the initial plenum/gap gas mass
   # gas_released = fis_gas_released     # coupling to a postprocessor which supplies the fission gas addition
   # quadrature = true
   # contact_pressure = contact_pressure
 # [../]
 # [./thermal_contact_top]
  #  type = GapHeatTransferLWR
  #  variable = temp
  #  master = 23
  #  slave = 24
  #  coord_type = XYZ
  #  initial_moles = initial_moles       # coupling to a postprocessor which supplies the initial plenum/gap gas mass
  #  gas_released = fis_gas_released     # coupling to a postprocessor which supplies the fission gas addition
  #  quadrature = true
  #  contact_pressure = contact_pressure
 # [../]
[]



[BCs]
# Define boundary conditions

  [./no_x_all] # pin pellets and clad along axis of symmetry (y)
    type = DirichletBC
    variable = disp_x
    boundary = '12 22'
    value = 0.0
  [../]

  [./no_y_clad_bottom] # pin clad bottom in the axial direction (y)
    type = DirichletBC
    variable = disp_y
    boundary = '1'
    value = 0.0
  [../]

  [./no_y_fuel_bottom] # pin fuel bottom in the axial direction (y)
    type = DirichletBC
    variable = disp_y
    boundary = '1020'
    value = 0.0
  [../]


  [./Pressure] #  apply coolant pressure on clad outer walls
    [./coolantPressure]
      boundary = '1 2 3'
      factor = 15.0e6
      function = pressure_ramp   # use the pressure_ramp function defined above
    [../]
  [../]

  [./PlenumPressure] #  apply plenum pressure on clad inner walls and pellet surfaces
    [./plenumPressure]
      boundary = '9'
      initial_pressure = 2.0e6   #---------------------(PWRs typically have a fill gas pressure of 1 - 3 MPa, i will try to find a source for this)--------------------------EDIT
      startup_time = 0
      R = 8.3143
      output_initial_moles = initial_moles       # coupling to post processor to get initial fill gas mass
      temperature = ave_temp_interior            # coupling to post processor to get gas temperature approximation
      volume = gas_volume                        # coupling to post processor to get gas volume
      material_input = fis_gas_released          # coupling to post processor to get fission gas added
      output = plenum_pressure                   # coupling to post processor to output plenum/gap pressure
    [../]
  [../]

[]

[CoolantChannel]
  [./convective_clad_surface] # apply convective boundary to clad outer surface
    boundary = '1 2 3'
    variable = temp
    inlet_temperature = 580      # K
    inlet_pressure    = 15.0e6   # Pa
    inlet_massflux    = 3800     # kg/m^2-sec
    rod_diameter      = 0.95e-2 # m
    rod_pitch         = 1.26e-2  # m
    heat_transfer_coefficient = 30000 # W/m^2-K
    linear_heat_rate  = power_history
    axial_power_profile = axial_peaking_factors
  [../]
[]
#[PlenumTemperature]
#  [./plenumTemp]
#    num_pellets = 1
#    temp = temp
#  [../]

[Materials]
  # Define material behavior models and input material property data

  [./fuel_thermal]                       # temperature and burnup dependent thermal properties of UO2 (bison kernel)
    type = ThermalFuel
    block = '3'
    model = 4 # NFIR
    temp = temp
#    burnup = burnup
    burnup_function = burnup
   [../]

  [./fuel_solid_mechanics_swelling]      # free expansion strains (swelling and densification) for UO2 (bison kernel)
    type = VSwellingUO2
    gas_swelling_type = MATPRO
    block = '3'
    temp = temp
#    burnup = burnup
    burnup_function = burnup
  [../]

  [./fuel_creep]                         # thermal and irradiation creep for UO2 (bison kernel)
     type = CreepUO2
    block = '3'
    disp_r = disp_x
    disp_z = disp_y
    temp = temp
#    fission_rate = fission_rate
    burnup_function = burnup
    youngs_modulus = 2.e11
    poissons_ratio = .345
    thermal_expansion = 10e-6
    grain_radius = 10.0e-6
    oxy_to_metal_ratio = 2.0
#    max_its = 1000
    output_iteration_info = false
    stress_free_temperature = 295.0
  [../]

  [./fuel_relocation]
    type = RelocationUO2
    block = '3'
#    burnup = burnup
    burnup_function = burnup
    diameter = 0.008256  # ------------------------------------------------------------------------------------------------------------------------------EDIT
    q = q
    gap = 100e-6 # cold diametral gap # ---------------------------------------------------------------------------------------------------------------EDIT
    burnup_relocation_stop = 1.e20
  [../]



  [./clad_thermal] # ----------------------------------------------------------------------------------------------------------------------------------EDIT
# general thermal property input (elk kernel)
    type = HeatConductionSiCSiC
    block = '1'
    temp = temp
    volumetric_irradiation_strain = vstrain
  [../]

  [./clad_solid_mechanics]  # -------------------------------------------------------------------------------------------------------------------------EDIT
# thermoelasticity and thermal and irradiation creep for Zr4 (bison kernel)
    type = NewMaterial
    block = '1'
    disp_r = disp_x
    disp_z = disp_y
    temp = temp
    fast_neutron_flux = fast_neutron_flux
    fast_neutron_fluence = fast_neutron_fluence
    youngs_modulus = 20.4e10
    poissons_ratio = 0.15
#    max_its = 1000         # ------------------------------- I added this for the mateiral iterations that are performed, remove it if it downt work --EDIT
  [../]

  [./fission_gas_release]
    type = Sifgrs
    block = '3'
    temp = temp
#    fission_rate = fission_rate        # coupling to fission_rate aux variable
    burnup_function = burnup
#    initial_grain_radius = 10e-6
    grain_radius = grain_radius
    gbs_model = true
  [../]

  [./clad_density]
    type = Density
    block = '1'
    density = 2580.0
    disp_r = disp_x
    disp_z = disp_y
  [../]
  [./fuel_density]
    type = Density
    block = '3'
    disp_r = disp_x
    disp_z = disp_y
  [../]
[]

[Dampers]
  [./limitT]
    type = MaxIncrement
    max_increment = 250.0
    variable = temp
  [../]
  [./limitX]
    type = MaxIncrement
    max_increment = 4e-5
    variable = disp_x
  [../]
[]

[Executioner]

  # PETSC options:
  #   petsc_options
  #   petsc_options_iname
  #   petsc_options_value
  #
  # controls for linear iterations
  #   l_max_its
  #   l_tol
  #
  # controls for nonlinear iterations
  #   nl_max_its
  #   nl_rel_tol
  #   nl_abs_tol
  #
  # time control
  #   start_time
  #   dt
  #   optimal_iterations
  #   iteration_window
  #   linear_iteration_ratio

  type = Transient


  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'


#petsc_options = '-ksp_gmres_modifiedgramschmidt'
#petsc_options_iname = '-snes_linesearch_type -ksp_gmres_restart -pc_type  -pc_composite_pcs -sub_0_pc_hypre_type -sub_0_pc_hypre_boomeramg_max_iter -sub_0_pc_hypre_boomeramg_grid_sweeps_all -sub_1_sub_pc_type -pc_composite_type -ksp_type -mat_mffd_type'
#petsc_options_value = 'basic                   201                 composite hypre,asm         boomeramg            2                                  2                                         lu                 multiplicative     fgmres    ds'

    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart -snes_ksp_ew_rtol0 -snes_ksp_ew_rtolmax -snes_ksp_ew_gamma -snes_ksp_ew_alpha -snes_ksp_ew_alpha2 -snes_ksp_ew_threshold'
    petsc_options_value = ' lu       superlu_dist                  51                              0.5                  0.9                  1                  2                   2                    0.1'


  line_search = 'none'


  l_max_its = 100
  l_tol = 8e-3

  nl_max_its = 30
  nl_rel_tol = 1e-4
  nl_abs_tol = 1e-10

  start_time = -200
  n_startup_steps = 1
  end_time = 1.5e8 # -------------------------------------------------------------------------------------------------------------------------------EDIT
  num_steps = 5000

  dtmax = 3e5
  dtmin = 1

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 2e2

#timestep_limiting_function = axial_peaking_factors #name of block    ##########################################
#max_function_change = 3e20 #some really large number
#force_step_every_function_point = true

    optimal_iterations = 12
    iteration_window = 1
    linear_iteration_ratio = 100
  [../]

  [./Quadrature]
    order = FIFTH
    side_order = SEVENTH
  [../]
[]

[Postprocessors]
  # Define postprocessors (some are required as specified above; others are optional; many others are available)

  [./ave_temp_interior]            # average temperature of the cladding interior and all pellet exteriors
     type = SideAverageValue
     boundary = '9'
     variable = temp
   [../]

  [./clad_swelling]      #--i changed this to average over the entire cladding instead of a single sideset (is this correct)--------------------------------------------------------EDIT
    type = ElementAverageValue
    block = '1'
    variable = vstrain
#    type = SideAverageValue
#    boundary = '5 6 7'
#    variable = vstrain
  [../]

  [./clad_inner_vol]              # volume inside of cladding
    type = InternalVolume
   boundary = '7'
    outputs = exodus
  [../]
  [./max_fuel_cl_temp]
    type = NodalMaxValue
    boundary = '12'
    variable = temp
  [../]
  [./max_fuel_penetration]
    type = NodalMaxValue
    boundary = '10'
    variable = penetration
 [../]
 [./max_contact_pr]
    type = ElementExtremeValue
    value_type = max
    block = '3'
    variable = contact_pressure
  [../]
  [./pellet_volume]               # fuel pellet total volume
    type = InternalVolume
    boundary = '8'
    outputs = exodus
  [../]
  [./avg_fuel_burnup]
    type = ElementAverageValue
    variable = burnup
    block = '3'
  [../]
  [./avg_clad_temp]               # average temperature of cladding interior
    type = SideAverageValue
    boundary = '7'
    variable = temp
  [../]

  [./fis_gas_produced]           # fission gas produced (moles)
    type = ElementIntegralFisGasGeneratedSifgrs
    variable = temp
    block = '3'
  [../]

  [./fis_gas_released]           # fission gas released to plenum (moles)
    type = ElementIntegralFisGasReleasedSifgrs
    variable = temp
    block = '3'
  [../]
  [./fis_gas_grain]
    type = ElementIntegralFisGasGrainSifgrs
    variable = temp
    block = '3'
    outputs = exodus
  [../]
  [./fis_gas_boundary]
    type = ElementIntegralFisGasBoundarySifgrs
    variable = temp
    block = '3'
    outputs = exodus
  [../]

  [./gas_volume]                # gas volume
    type = InternalVolume
    boundary = '9'
    execute_on = linear
  [../]

  [./flux_from_clad]           # area integrated heat flux from the cladding
    type = SideFluxIntegral
    variable = temp
    boundary = 5
    diffusivity = thermal_conductivity
  [../]

  [./flux_from_fuel]          # area integrated heat flux from the fuel
    type = SideFluxIntegral
    variable = temp
    boundary = 10
    diffusivity = thermal_conductivity
  [../]

  [./_dt]                     # time step
    type = TimestepSize
  [../]

  [./nonlinear_its]           # number of nonlinear iterations at each timestep
    type = NumNonlinearIterations
  [../]

  [./rod_total_power]
    type = ElementIntegralPower
    variable = temp
#    fission_rate = fission_rate
    burnup_function = burnup
    block = '3'
  [../]

  [./rod_input_power]
#    type = PiecewiseLinear # PlotFunction
    type = FunctionValuePostprocessor
    function = power_history
    scale_factor = 1 # rod height
  [../]

#  [./MyYoungsModulus]
#    type = ElementIntegralPower
#    variable =
#    block = clad
#  [../]

  [./max_dispx_fuel]
    type = NodalExtremeValue
    value_type = max
    block = '3'
    variable = disp_x
  [../]


  [./max_dispx_clad]
    type = NodalExtremeValue
    value_type = max
    block = '1'
    variable = disp_x
  [../]

[]

[Outputs]
  # Define output file(s)
  interval = 1
#  output_initial = true
#  exodus = true
  print_linear_residuals = true
  print_perf_log = true
  [./console]
    type = Console
    max_rows = 25
  [../]

  [./csv]
    type = CSV
    interval = 1
  [../]

[./exodus]            ################
type = Exodus
interval = 1
[../]

[]
