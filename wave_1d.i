# 1D wave equation
# elasticity basic: see (modules/tensor_mechanics/test/tests/ad_elastic/finite_elastic.i)
# M*accel + K*disp = 0 which is equivalent to
# density*accel + Div Stress = 0
# The first term on the left is evaluated using the Inertial force kernel
# The last term on the left is evaluated using StressDivergenceTensors
#
# The displacement at the second, third and fourth node at t = 0.1 are
# -8.021501116638234119e-02, 2.073994362053969628e-02 and  -5.045094181261772920e-03, respectively

# TODO: test PresetDisplacemenet, see
# (modules/tensor_mechanics/test/tests/dynamics/prescribed_displacement/3D_QStatic_1_Ramped_Displacement.i)
# use a half sine wave

[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 100
  xmin = 0.0
  xmax = 10.0
[]

[GlobalParams]
  displacements = 'disp_x'
[]

[Variables]
  [./disp_x]
  [../]
[]

[AuxVariables] 
  [./accel_x]
  [../]
  [./vel_x]
  [../]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./solid_x]
    type = StressDivergenceTensors
    variable = disp_x
    displacements = 'disp_x'
    component = 0
    # stiffness_damping_coefficient = 0.000025
  [../]
  [./inertia_x] # M*accel + eta*M*vel
    type = InertialForce
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25 # Newmark time integration
    gamma = 0.5 # Newmark time integration
    eta = 0.0
  [../]
[]

[AuxKernels]
  [./accel_x] # Calculates and stores acceleration at the end of time step
    type = NewmarkAccelAux
    variable = accel_x
    displacement = disp_x
    velocity = vel_x
    beta = 0.25
    execute_on = timestep_end
  [../]
  [./vel_x] # Calculates and stores velocity at the end of the time step
    type = NewmarkVelAux
    variable = vel_x
    acceleration = accel_x
    gamma = 0.5
    execute_on = timestep_end
  [../]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./strain_xx]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_xx
    index_i = 0
    index_j = 0
  [../]
[]

[BCs]
  [./leftBC]
    type = ADFunctionDirichletBC
    variable = disp_x
    boundary = left
    beta = 0.25
    function = 'if(t<=1, 0.01*sin(pi*t), 0)'
    velocity = vel_x
    acceleration = accel_x
  [../]
  [./rightBC]
    type = ADFunctionDirichletBC
    variable = disp_x
    boundary = right
    beta = 0.25
    function = 'if(t<=1, 0.01*sin(pi*t), 0)'
    # function = '0.01*t'
    velocity = vel_x
    acceleration = accel_x
  [../]
[]

[Materials]
  [./elasticity]
    type = ComputeIsotropicElasticityTensor
    poissons_ratio = 0.3
    youngs_modulus = 0.01 #Pa
  [../]
  [./strain]
    type = ComputeSmallStrain
    block = 0
    displacement = 'disp_x'
  [../]
  [./stress]
    type = ComputeLinearElasticStress
    block = 0
  [../]
  [./density]
    type = GenericConstantMaterial
    block = 0
    prop_names = density
    prop_values = 2e-3 #kg/m3
  [../]
[]

[Executioner]
  type = Transient
  start_time = 0
  end_time = 3.0
  l_tol = 1e-6
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  dt = 1e-2
  timestep_tolerance = 1e-6
[]

[Postprocessors]
  [./disp_x_rightBC]
    type = PointValue
    point = '10 0 0'
    variable = disp_x
  [../]
[]

[Outputs]
  exodus = true
  [./csv]
    type = CSV 
  [../]
[]