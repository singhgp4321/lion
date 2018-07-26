[Contact]
  # Define mechanical contact
  [./pellet_upper-punch]
    master = pellet_top
    slave = upper_punch_bottom

    system = Constraint
    formulation = penalty
    penalty = 0.9e14
    model = frictionless
    normal_smoothing_distance = 0.1
    normalize_penalty = true

    disp_x = disp_x
    disp_y = disp_y
#    penalty = 1e7
  [../]

  [./pellet_lower-punch]
    master = pellet_bottom
    slave = lower_punch_top

    system = Constraint
    formulation = penalty
    penalty = 0.9e14
    model = frictionless
    normal_smoothing_distance = 0.1
    normalize_penalty = true

    disp_x = disp_x
    disp_y = disp_y
#    penalty = 1e7
  [../]

  [./pellet_die]
    master = pellet_outer
    slave = die_inner

    system = Constraint
    formulation = penalty
    penalty = 0.9e14
    model = frictionless
    normal_smoothing_distance = 0.1
    normalize_penalty = true

    disp_x = disp_x
    disp_y = disp_y
#    penalty = 1e7
  [../]

  [./die_lower-punch]
    master = die_inner
    slave = lower_punch_outer

    system = Constraint
    formulation = penalty
    penalty = 0.9e14
    model = frictionless
    normal_smoothing_distance = 0.1
    normalize_penalty = true

    disp_x = disp_x
    disp_y = disp_y
#    penalty = 1e7
  [../]

  [./die_upper-punch]
    master = die_inner
    slave = upper_punch_outer

    system = Constraint
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
